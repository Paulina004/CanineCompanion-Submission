"""
Embedding PDF Documents into Pinecone Index

This script facilitates the embedding of text content from PDF documents into a Pinecone index, 
enhancing accessibility and searchability. To utilize this script effectively for new PDFs, 
adhere to the following steps:

1. Prepare PDF Files: Organize the PDF files you intend to embed into the directory './PDFs/new_PDFs' 
for seamless processing.

2. Update PDF Directory: Modify the 'pdf_directory' variable within the script to point to the directory 
containing your PDF files. Ensure clarity in specifying the path. For instance, if your PDFs are stored 
in a directory named 'new_PDFs' within the current directory, set 'pdf_directory = "./PDFs/new_PDFs/"'.

3. File Extension Verification: Confirm that all PDF files within the designated directory possess 
the '.pdf' extension for accurate processing.

4. Execution: Execute the script. It systematically iterates through each PDF file in the specified directory, 
extracting text content, generating embeddings using OpenAI's text embedding model, and seamlessly integrating them, alongside their corresponding texts, into the Pinecone index named 'dog-faq-index'.

5. Verification and Transfer: Upon script completion, verify its functionality by executing the 'queries_v2' 
file. Once you've received answers from the PDFs, relocate these PDFs from the './PDFs/new_PDFs' directory to the './PDFs' directory for organized maintenance and future reference.
"""

from openai import OpenAI
import os
from dotenv import load_dotenv
from langchain.document_loaders import UnstructuredPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from pinecone import Pinecone, ServerlessSpec
import time

load_dotenv()

# Initialize OpenAI client
client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

MODEL = "text-embedding-3-small"

# Directory containing PDFs
pdf_directory = "./PDFs/new_PDFs"

# List all PDF files in the directory
pdf_files = [os.path.join(pdf_directory, f) for f in os.listdir(pdf_directory) if f.endswith('.pdf')]

# Initialize Pinecone client
pc = Pinecone(api_key=os.getenv('PINECONE_API_KEY'))

# Define Pinecone index specifications
spec = ServerlessSpec(cloud="aws", region="us-west-2")
index_name = 'dog-faq-index'

# Check if index already exists, if not, create a new one
if index_name not in pc.list_indexes().names():
    pc.create_index(
        index_name,
        dimension=512,  # Assuming dimensionality of embeddings is 512
        metric='dotproduct',
        spec=spec
    )
    # Wait for index to be initialized
    while not pc.describe_index(index_name).status['ready']:
        time.sleep(1)

# Connect to the Pinecone index
index = pc.Index(index_name)

# Iterate over each PDF file
for pdf_file in pdf_files:
    # Load and preprocess the PDF document
    loader = UnstructuredPDFLoader(pdf_file)
    data = loader.load()
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=0)
    texts = text_splitter.split_documents(data)
    
    # Extract text content from the list of documents
    texts = [doc.page_content for doc in texts]
    
    # Extract embeddings from the PDF document
    res = client.embeddings.create(input=texts, model=MODEL)
    embeds = [record.embedding for record in res.data]

    # Insert embeddings and corresponding texts into the Pinecone index
    batch_size = 32
    for i in range(0, len(texts), batch_size):
        # Set end position of batch
        i_end = min(i + batch_size, len(texts))
        # Get batch of lines and IDs
        lines_batch = texts[i: i + batch_size]
        embeds_batch = embeds[i: i + batch_size]
        ids_batch = [str(n) for n in range(i, i_end)]
        # Prepare metadata and upsert batch
        meta = [{'text': line} for line in lines_batch]
        to_upsert = zip(ids_batch, embeds_batch, meta)
        # Upsert to Pinecone
        index.upsert(vectors=list(to_upsert))

    # Optional: Wait to avoid rate limiting
    time.sleep(1)
