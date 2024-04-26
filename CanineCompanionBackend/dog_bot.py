from openai import OpenAI
import os
from dotenv import load_dotenv
from pinecone import Pinecone, ServerlessSpec
from pdfs import pdf_urls
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

# Load environment variables
load_dotenv()

class DogBot:
    def __init__(self):
        # Initialize OpenAI client
        self.openai_api_key = os.getenv('OPENAI_API_KEY')
        self.client = OpenAI(api_key=self.openai_api_key) 
        # Initialize Pinecone client
        self.pinecone_api_key = os.getenv('PINECONE_API_KEY')
        self.pc = Pinecone(api_key=self.pinecone_api_key) 
        self.MODEL = "text-embedding-3-small"
        # Define Pinecone index specifications
        self.spec = ServerlessSpec(cloud="aws", region="us-west-2")
        self.index_name = 'dog-faq-index'
        self.index = self.pc.Index(self.index_name)


    def run_query(self, query):
        # Create the query embedding - similarity search
        xq = self.client.embeddings.create(input=query, model=self.MODEL).data[0].embedding

        # Query the Pinecone index, returning the top 5 most similar results
        res = self.index.query(vector=[xq], top_k=5, include_metadata=True)

        # Sort matches by relevance (if necessary)
        sorted_matches = sorted(res['matches'], key=lambda x: x['score'], reverse=True)
        print("Sorted Matches:", type(sorted_matches))

        # Extract text from the top match
        top_prompt = sorted_matches[0]['metadata']['text']
        print("Top Prompt:", type(top_prompt))
        print(top_prompt[:50])

        

        # Check if the response matches the query
        return self.process_prompt(query, top_prompt)



    def process_prompt(self, query, pinecone_ans):
        completion = self.client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages = [
                {
                    "role": "user", 
                    "content": f"Based on the provided data: {pinecone_ans}, " +
                            "generate a concise summary and categorize the information."
                }

            ],
            max_tokens=50, 
            temperature=0.7, 
            stop=["\n"]  
        )
        response = completion.choices[0].message.content.strip()
        return self.check_answer(query, response, pinecone_ans)

    def check_answer(self, query, data, pinecone_ans):
        prompt = f"Given this query: '{query}', is there a somewhat an appropriate answer here in this data?'{data}'. Only response with Yes or No."

        response = self.client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "user", "content": prompt }
            ],
            max_tokens=50, 
            temperature=0.7, 
        )   

        response_content = response.choices[0].message.content.lower()
        if "yes" in response_content:
            return {"yes": data}, pinecone_ans
        return {"no": ""}, ""

    from sklearn.feature_extraction.text import TfidfVectorizer
    from sklearn.metrics.pairwise import cosine_similarity
    def compute_cosine_similarity(self, query):
        prompt = f"Given this query: '{query}', you must select the most relevant PDF title from the following options: {list(pdf_urls.keys())}. You must pick one, and only provide the title as shown in the list of options.."
        response = self.client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[{"role": "user", "content": prompt}],
            max_tokens=50, 
            temperature=0.7, 
        )   

        selected_title = response.choices[0].message.content.strip()

        # Remove quotes from the selected title
        selected_title = selected_title.replace("'", "").replace('"', '')

        # Compute TF-IDF vectors for the response and PDF titles
        tfidf_vectorizer = TfidfVectorizer()
        response_tfidf = tfidf_vectorizer.fit_transform([query])
        titles_tfidf = tfidf_vectorizer.transform(pdf_urls.keys())

        # Calculate cosine similarity between the response and each title
        similarities = cosine_similarity(response_tfidf, titles_tfidf)

        # Get the index of the title with the highest similarity
        max_index = similarities.argmax()

        # Return the most similar PDF title
        if similarities[0][max_index] > 0.4:  # Adjust the threshold as needed
            return pdf_urls[list(pdf_urls.keys())[max_index]]
        else:
            return "n/a"


    def query_handler(self, query):
        ans, pinecone_ans = self.run_query(query)
        if "yes" in ans:
            yes_answer = ans["yes"]
            prompt = f"Given this query: '{query}', along with this answer: '{yes_answer}', please provide the most appropriate short and concise response, limited to 1-2 sentences."
        else:
            prompt = f"Given this query: '{query}', please provide the most appropriate short and concise response, limited to one sentence."

        response = self.client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[{"role": "user", "content": prompt}],
            max_tokens=50,
            temperature=0.7
        ).choices[0].message.content.strip()

        if "yes" not in ans:
            response = response
        else:
            print("FOUND A SOURCE")
            citation = self.compute_cosine_similarity(query)
            if citation == 'n/a':
                response = response
            else: 
                response = response + f"\n\nSource: {self.compute_cosine_similarity(query)}"
            
           

        return response

