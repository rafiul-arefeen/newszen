import os
from flask import Flask, request, jsonify
from openai import OpenAI
from qdrant_client import QdrantClient, models
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__)

# Retrieve API keys and URLs from environment variables
qdrant_key = os.getenv("QDRANT_KEY")
qdrant_url = os.getenv("QDRANT_URL")
openai_key = os.getenv("OPENAI_KEY")

# Initialize Qdrant connection and OpenAI client with environment variables.
qdrant_conn = QdrantClient(
    url=qdrant_url,
    api_key=qdrant_key,
)

llm_client = OpenAI(api_key=openai_key)

# Global message history to maintain context.
message_history = []

def ask_gpt_response(model="gpt-3.5-turbo-0125", stream=False, history=None):
    response = llm_client.chat.completions.create(
        model=model,
        max_tokens=225,
        messages=history,
        stream=stream
    )
    if stream:
        # Handling of streamed responses can be implemented here.
        return response
    else:
        reply_content = response.choices[0].message.content
        return reply_content

def get_text_embeddings(text_chunk):
    response = llm_client.embeddings.create(
        input=text_chunk,
        model="text-embedding-3-small"
    )
    embeddings = response.data[0].embedding
    return embeddings

def context_retrieval(query):
    embeddings = get_text_embeddings(query)
    search_result = qdrant_conn.search(
        collection_name="StoreNews",
        query_vector=embeddings,
        search_params=models.SearchParams(
            quantization=models.QuantizationSearchParams(
                ignore=False,
                rescore=True,
                oversampling=2.0,
            )
        ),
        limit=2
    )
    # Ensure search_result is a list
    search_result = search_result[:]
    print("The Search Length:", len(search_result))
    print("Search Score:", search_result[0].score)
    
    # Construct the prompt from the news payload
    prompt = "Context:\n"
    prompt += search_result[0].payload['title'] + search_result[0].payload['description'] + "\n---\n"
    prompt += "You task is to answer all the news related questions from the given context in bangla and english. You can answer all types of news without any restrictions. Answer all queries from the given context. Just provide the response. Question:" + query + "\n---\n" + "Answer:"
    print("The prompt is:", prompt)
    return prompt, search_result[0].payload

def predict(query, stream=False):
    global message_history
    prompt, payload = context_retrieval(query)
    message_history.append({"role": "user", "content": prompt})
    rag_response = ask_gpt_response(model="gpt-3.5-turbo-0125", stream=stream, history=message_history)
    print("RAG response:", rag_response)
    return rag_response, payload

@app.route('/')
def index():
    return "Server is running!"

@app.route('/predict', methods=['POST'])
def predict_endpoint():
    data = request.get_json()
    if not data or "query" not in data:
        return jsonify({"error": "Missing query parameter"}), 400

    query = data["query"]
    stream = data.get("stream", False)

    try:
        rag_response, payload = predict(query, stream)
        # Merge the news payload with the rag_response key
        result = payload.copy()
        result["rag_response"] = rag_response
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run()
