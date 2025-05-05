from openai import OpenAI
from qdrant_client import QdrantClient, models


qdrant_key = "api-key"
qdrant_url = "url"
qdrant_conn = QdrantClient(
    url=qdrant_url,
    api_key=qdrant_key,
)
message_history = []
openai_key = "api-key"
llm_client = OpenAI(api_key=openai_key)

def ask_gpt_response(models="gpt-3.5-turbo-0125", stream=True, history=None):
    global message_history, llm_max_token, campaign_dict
    response = llm_client.chat.completions.create(
        model=models,
        max_tokens=225,
        messages=history,
        stream=stream
    )
    if stream:
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
        limit= 1
    )
    search_result = search_result[:]
    print("The Search Length: ", len(search_result))
    print("Search Score: ", search_result[0].score)
    prompt = "Context:\n"
    prompt += search_result[0].payload['news_content'] + "\n---\n"
    prompt += "Question:" + query + "\n---\n" + "Answer:"
    print("The prompt is ",prompt)
    return prompt, search_result[0]. payload


def predict(query, stream):
    global message_history
    prompt, payload = context_retrieval(query)
    message_history.append({"role": "user", "content": prompt})
    rag_response = ask_gpt_response(models="gpt-3.5-turbo-0125", stream=stream, history=message_history)
    print("rag",rag_response)
    return rag_response, payload

# print(predict("Which person had a meeting with american muslim and tell me the summary of it", False))
