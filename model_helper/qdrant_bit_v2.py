from PyPDF2 import PdfReader
from langchain.text_splitter import CharacterTextSplitter
import time
from qdrant_client import QdrantClient, models
from qdrant_client.http.models import PointStruct
from openai import OpenAI
import uuid

openai_key = "OPENAI_KEY"
qdrant_key = "Qdrant_KEY"
qdrant_url = "Qdrant_URL"



connection = QdrantClient(
    url="Qdrant_URL",
    api_key="Qdrant_KEY",
)
llm_client = OpenAI(api_key=openai_key)

connection = QdrantClient(url=qdrant_url, api_key=qdrant_key, )

collection_name = "example_collection2"



def ask_llm_model(stream=False, prompt=None):
    messages = [{"role": "user", "content": prompt}]
    response = llm_client.chat.completions.create(
        model="gpt-3.5-turbo",
        max_tokens=512,
        messages=messages,
        stream=stream
    )
    if stream:
        return response
    else:
        reply_content = response.choices[0].message.content
        return reply_content


def file_data_extract(doc_path):
    text = ""
    with open(doc_path, 'rb') as file:
        pdf_reader = PdfReader(file)

        for page in pdf_reader.pages:
            text += page.extract_text()
    return text


def get_text_embeddings(text_chunk):
    response = llm_client.embeddings.create(
        input=text_chunk,
        model="text-embedding-3-small"
    )
    embeddings = response.data[0].embedding
    return embeddings


def get_vectorize_points(text_chunks):
    points = []
    for idx, chunk in enumerate(text_chunks):
        embeddings = get_text_embeddings(chunk)
        point_id = str(uuid.uuid4())

        points.append(PointStruct(id=point_id, vector=embeddings, payload={"text": chunk}))
    return points


def qdrant_cluster_load(cluster_name, doc_path, create_cluster=False, embedding_model="text-embedding-3-small"):
    if create_cluster:
        connection.create_collection(
            collection_name=cluster_name,
            vectors_config=models.VectorParams(
                size=1536,
                distance=models.Distance.DOT,
                on_disk=True,
            ),
            optimizers_config=models.OptimizersConfigDiff(
                default_segment_number=5,
                indexing_threshold=0,
            ),
            quantization_config=models.BinaryQuantization(
                binary=models.BinaryQuantizationConfig(always_ram=True),
            ),
        )

    text_data = file_data_extract(doc_path)

    text_splitter = CharacterTextSplitter(
        separator="\n",
        chunk_size=800,
        chunk_overlap=400,
        length_function=len
    )
    text_chunks = text_splitter.split_text(text_data)
    embedded_points = get_vectorize_points(text_chunks)
    qdrant_load_stat = connection.upsert(
        collection_name=collection_name,
        wait=True,
        points=embedded_points
    )
    connection.update_collection(
        collection_name=collection_name,
        optimizer_config=models.OptimizersConfigDiff(
            indexing_threshold=20000
        )
    )
    print(qdrant_load_stat)


def context_retrieval(query, collection_name):
    embeddings = get_text_embeddings(query)
    search_result = connection.search(
        collection_name=collection_name,
        query_vector=embeddings,
        search_params=models.SearchParams(
            quantization=models.QuantizationSearchParams(
                ignore=False,
                rescore=True,
                oversampling=2.0,
            )
        )
    )
    search_result = search_result[:]
    print("The Search Length: ", len(search_result))
    print("Search Score: ", search_result[0].score)
    prompt = "Context:\n"
    for result in search_result:
        result = result.payload['text'].replace('\n',' ')
        prompt += result + "\n---\n"
    prompt += "Question:" + query + "\n---\n" + "Answer:"
    print("The prompt is ",prompt)
    return prompt


def predict(query, collection_name, stream_response):
    prompt = context_retrieval(query, collection_name)
    llm_response = ask_llm_model(stream=stream_response, prompt=prompt)
    return llm_response





if __name__ == '__main__':
    while True:
        # info = connection.get_collection(collection_name=collection_name)
        # print("Collection info:", info)
        query = input("Enter query: ")
        start_time = time.time()
        stream_response = True

        llm_response = predict(query=query, collection_name=collection_name, stream_response= stream_response)
        if stream_response is True:
            first_chunk_received = False
            end_time = 0
            response = ""
            for response_chunk in llm_response:
                if not first_chunk_received:
                    end_time = time.time()
                    first_chunk_received = True
                response_chunk = response_chunk.choices[0].delta.content
                if response_chunk is not None:
                    response = response + response_chunk
            print("Output Response: ", response)

            print("First Chunk Response Time: ", end_time - start_time)
            end_time = time.time()
            print("Final Response Time: ", end_time-start_time)

        else:
            end_time = time.time()
            print("Output Response: ", llm_response)
            print("First Chunk Response Time: ", end_time - start_time)


