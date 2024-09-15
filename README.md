# News Scraping and Embedding Project for Trademarkia Assignment 

This project scrapes the latest news articles from Times of India, processes the content, and converts the text into embeddings using Hugging Face models. The embeddings are stored in Pinecone for further retrieval and query-based searching. It also includes a Flask API for users to query the processed data.

## Features

- Scrapes the latest news articles and caches the content using Redis.
- Splits the article text into manageable chunks using the Hugging Face `RecursiveCharacterTextSplitter`.
- Converts the text into embeddings using Hugging Face embeddings.
- Stores the embeddings in Pinecone for efficient retrieval.
- Allows users to query the stored embeddings using a Groq-powered LLM (e.g., Mixtral 7B).
- API rate limiting and request logging using SQLite.
  
## Project Structure

- **`scrapper.py`**: Scrapes news articles from the Times of India and caches the content.
- **`embedding.py`**: Converts scraped content into embeddings using Hugging Face models and stores them in Pinecone.
- **`main.py`**: Provides an API using Flask to query the embeddings and retrieve relevant articles.
- **`.env`**: Stores API keys for Pinecone and Groq (not included in the repository).

## Installation

1. **Clone the repository**:
   ```
   git clone https://github.com/your-username/your-repo-name.git
   cd your-repo-name
   ```

2. **Install the required dependencies**:
   ```
   pip install -r requirements.txt
   ```

3. **Set up your environment variables**:
   Create a `.env` file in the root of the project and add your API keys:
   ```
   PINECONE_API_KEY=your_pinecone_api_key
   GROQ_API_KEY=your_groq_api_key
   ```

4. **Set up Redis**:
   Make sure Redis is installed and running on your local machine. The project connects to Redis at `localhost:{your_defined_redis_port}`.

5. **Set up the SQLite database**:
   The project uses an SQLite database to track API usage.
   ```
   python main.py
   ```

## Usage

1. **Scrape News and Store Embeddings**:
   The process of scraping news, converting text to embeddings, and storing them in Pinecone happens automatically when the Flask app starts. You can run this in a separate thread as shown in `main.py`.

2. **Run the Flask API**:
   To start the Flask API server, run the following command:
   ```
   python main.py
   ```
   The API will be available at `http://localhost:5000`.

3. **API Endpoints**:

   - **Health Check**: 
     ```
     GET /health
     ```
     Returns a simple message to indicate that the server is running.

   - **Search**:
     ```
     GET /search?user_id=<user_id>&text=<search_text>&top_k=<top_k>&threshold=<threshold>
     ```
     Searches the stored news embeddings based on the provided text and returns relevant results.

     Parameters:
     - `user_id`: A unique identifier for the user making the request.
     - `text`: The search query.
     - `top_k`: The number of top results to return (default: 5).
     - `threshold`: The minimum similarity threshold for filtering results (default: 0.2).

4. **Caching**:
   The scraped news content and LLM responses are cached using Redis to improve performance.

## Requirements

- Python 3.7+
- Redis
- Pinecone (for vector storage)
- Hugging Face (for embeddings)
- Groq API (for the LLM)

## Dependencies

The required Python packages can be found in `requirements.txt`. Here are some key dependencies:
- `requests`: For making HTTP requests.
- `beautifulsoup4`: For scraping content from HTML.
- `redis`: For caching and storing data.
- `langchain_text_splitters`: For splitting text into manageable chunks.
- `pinecone`: For embedding storage.
- `flask`: For the API.
- `dotenv`: For loading environment variables.


## DOCKERISATION STILL IN PROGRESS
