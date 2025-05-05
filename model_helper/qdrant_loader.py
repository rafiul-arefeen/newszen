from qdrant_client import QdrantClient, models
from qdrant_client.http.models import PointStruct
from openai import OpenAI
import uuid
import pandas as pd

def qdrant_data_delete():
    collection_name = "StoreNews"
    qdrant_key = "api-key"
    qdrant_url = "url"
    qdrant_conn = QdrantClient(
        url=qdrant_url,
        api_key=qdrant_key,
    )
    collection_status = qdrant_conn.collection_exists(collection_name=collection_name)
    if collection_status:
        points = qdrant_conn.scroll(
            collection_name=f"{collection_name}",
            scroll_filter=models.Filter(
                must=[
                    models.FieldCondition(key="file_id", match=models.MatchValue(value=file_id)),
                ]
            ),
            limit=2000,
            with_payload=True,
            with_vectors=False,
        )
        # Assuming points is the list of Record objects
        ids_list = [record.id for record in points[0]]
        print(ids_list)
        if ids_list:
            delete_stat = qdrant_conn.delete(
                collection_name=f"{collection_name}",
                points_selector=models.PointIdsList(
                    points=ids_list,
                ),
            )
            print(delete_stat.status)
            return delete_stat.status


def qdrant_data_load():
    collection_name = "StoreNews"
    qdrant_key = "api-key"
    qdrant_url = "url"
    qdrant_conn = QdrantClient(
        url=qdrant_url,
        api_key=qdrant_key,
    )

    openai_key = "api-key"
    llm_client = OpenAI(api_key=openai_key)

    collection_status = qdrant_conn.collection_exists(collection_name=collection_name)

    if not collection_status:
        qdrant_conn.create_collection(
            collection_name=collection_name,
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

    file_path = 'NewsZen_AI_Mini_Dataset.xlsx'
    df = pd.read_excel(file_path)

    df = df.rename(columns={
        df.columns[0]: "news_heading",
        df.columns[1]: "news_content",
        df.columns[2]: "news_link",
        df.columns[3]: "news_category",
        df.columns[4]: "img_link"
    })
    embedded_points = []
    for index, row in df.iterrows():
        row_dict = row.to_dict()
        print(index)
        response = llm_client.embeddings.create(
            input=row_dict['news_content'],
            model="text-embedding-3-small"
        )
        embeddings = response.data[0].embedding
        point_id = str(uuid.uuid4())
        print(f"Row {index}: {row_dict}")
        embedded_points.append(PointStruct(id=point_id, vector=embeddings, payload=row_dict))



    qdrant_load_stat = qdrant_conn.upsert(
        collection_name=collection_name,
        wait=True,
        points=embedded_points
    )
    qdrant_conn.update_collection(
        collection_name=collection_name,
        optimizer_config=models.OptimizersConfigDiff(
            indexing_threshold=20000
        )
    )
    print(qdrant_load_stat.status)
    return qdrant_load_stat.status

qdrant_data_delete()
qdrant_data_load()
