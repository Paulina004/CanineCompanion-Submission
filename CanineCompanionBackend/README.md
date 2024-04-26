# Retrieval-Augmented Generation (RAG) Architecture

The Retrieval-Augmented Generation (RAG) architecture combines the strengths of retrieval-based and generation-based models to enhance the quality and reliability of AI-generated responses. It improves the performance of a personalized care suggestions chatbot integrated into the Canine Companion iOS app.

## Data Collection and Processing

The RAG model leverages OpenAI's GPT model to provide users with detailed information and tips regarding dog care. Data for the RAG model includes articles related to dog care, which are saved as PDFs, loaded, and processed using LangChain's PDFLoader. Additional data sources are scraped or collected from the internet to enrich the knowledge base of the RAG model.

## Functionality

1. **Retrieval**: The RAG model retrieves relevant information from the knowledge base to support the generation of responses to user queries.
2. **Generation**: Utilizing the retrieved information and its inherent generative capabilities, the model crafts responses that are contextually relevant and informative.
3. **Ethical AI**: The RAG architecture promotes ethical AI practices by enabling the model to acknowledge its limitations and refrain from providing inaccurate or misleading information.

## Transparency and Safety

By integrating the RAG architecture, the chatbot ensures a safer and more transparent user experience. Rather than generating unreliable or erroneous responses, the model can indicate when it lacks sufficient data or expertise on a particular topic, fostering trust and confidence among users.

# Running the Flask Application

## Prerequisites

- Python installed on your system.
- Required dependencies installed using the `requirements.txt` file.

## Installation

1. Clone the repository to your local machine.
2. Navigate to the project directory.

## Usage

1. First get into the CanineCompanionBackend directory:
   ```bash
      cd CanineCompanionBackend

2. Install dependencies using the following command:
   ```bash
   pip install -r requirements.txt

3. Run the Flask application by executing the following command:
   ```bash
   python app.py

4. Once the application is running (in the terminal enter: cd 'CanineCompanionBackend' then enter: 'python3 app.py' or 'python app.py'). In a new terminal you can send POST requests to http://127.0.0.1:5000/query with a JSON payload containing the query text. For example:
   ```bash
   curl -X POST -H "Content-Type: application/json" -d '{"query": "What are some common dog breeds?"}' http://127.0.0.1:5000/query

5. Postman

   To make a POST request to the Flask API endpoint using Postman, follow these steps:

   1. Open Postman and create a new request.

   2. Set the request type to POST.

   3. Enter the URL of your Flask API endpoint: `http://127.0.0.1:5000/query`.

   4. In the Headers section, add a key-value pair with Key as `Content-Type` and Value as `application/json`.

   5. In the Body section, select the raw option and choose JSON (application/json) from the dropdown.

   6. Enter your JSON payload in the body. For example:
      ```json
      {
         "query": "What are some common dog breeds?"
      }

6. (Optional) **Expand Your PDF Database**:
To enrich our Pinecone index with additional PDF files, simply place the new PDF(s) in the designated "new_PDFs" directory. Afterwards, execute the provided script `embed_pdf_to_pinecone.py`. Running this script will seamlessly incorporate the embeddings of the new PDF files into Pinecone, thereby augmenting the repository of dog-related knowledge. This process empowers your system to address a broader spectrum of inquiries related to canine care and welfare. Afterwards more those new pdf files into the PDFs directory to archive them.

```bash
python embed_pdf_to_pinecone.py



# Research Resources

1. **OpenAI Cookbook**: Explore practical examples, tips, and best practices in the OpenAI Cookbook. Join the community to learn from others and share your experiences. [OpenAI Cookbook](https://chat.openai.com/c/549d5c55-e373-4d2f-9239-343f771aeb5e)

2. **OpenAI Library Documentation**: Refer to the official OpenAI library documentation for comprehensive guides, API references, and usage examples. Stay updated with the latest features and changes. [OpenAI Library Documentation](https://platform.openai.com/docs/libraries/python-library)

3. **LangChain Documentation**: Access documentation for LangChain to learn about text processing and analysis tools. Get started with tutorials, guides, and reference materials. [LangChain Documentation](https://python.langchain.com/docs/get_started/introduction)

4. **Pinecone Documentation Repository**: Explore the Pinecone documentation repository on GitHub for information about the Pinecone Python client. Stay informed about updates, releases, and best practices. [Pinecone Documentation Repository](https://github.com/pinecone-io/pinecone-python-client/blob/main/README.md)

By leveraging these resources, you can enhance your understanding, troubleshoot issues, and optimize your usage of the libraries and tools in your projects.


This README.md file provides comprehensive instructions on how to install dependencies, run the Flask application, and utilize the provided API endpoint with both curl and a Swift frontend example.


