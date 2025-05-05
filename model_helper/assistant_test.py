from openai import OpenAI
import time
llm_client = OpenAI(api_key="API KEY")
def ask(prompt):
    start_time = time.time()  # Record the start time
    messages = [
        {"role": "user", "content": prompt}
    ]
    print(messages)
    stream = llm_client.beta.threads.create_and_run(
        assistant_id="Assistant_ID",
        thread={
            "messages": messages
        },
        stream=True
    )
    sentence = ""
    n = 0
    for chunk in stream:
        if chunk.event == "thread.run.completed":
            break
        if chunk.event == "thread.message.delta":
            chunk_message = chunk.data.delta.content[0].text.value
            # print(chunk_message)
            if n == 0:
                end_time = time.time()  # Record the end time
                elapsed_time = end_time - start_time  # Calculate the elapsed time
                print(f"Time taken to run the main function: {elapsed_time} seconds")
                n = 1
            sentence = sentence + chunk_message
    print(sentence)
ask("What is the news of today")

