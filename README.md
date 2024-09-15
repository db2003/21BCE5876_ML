# Document Retrieval System for Chat Applications (done as online Trademarkia Assignment)

This project is a backend for document retrieval, designed to generate context for large language models (LLMs) during inference. It scrapes the latest news articles, converts the content into embeddings, and stores them for fast retrieval. Additionally, the system provides a cache to ensure faster responses and tracks API usage to limit excessive requests.

## Features

- **News Article Scraping**: A background process that starts as soon as the server is up, scraping news articles and processing them for retrieval.
- **Document Retrieval**: Uses embeddings for document similarity searches. The system supports multiple encoders and stores embeddings in Pinecone.
- **Caching**: Responses are cached using Redis for faster retrieval and to minimize redundant computations.
- **Rate Limiting**: Users are limited to 5 requests, tracked via `user_id`. Excessive requests will result in an HTTP 429 status code.
- **API Logging**: Logs request details and tracks inference time for each request.
- **Dockerization**: The entire application is Dockerized for easy deployment.

## Project Structure

- **`scrapper.py`**: Handles news scraping and stores the content in a structured format for embedding generation.
- **`embedding.py`**: Converts scraped content into embeddings using Hugging Face models and stores them in Pinecone.
- **`main.py`**: Flask-based backend API with endpoints for document search, health checks, and user request tracking.
- **`.env`**: Stores sensitive API keys (e.g., Pinecone, Groq) securely.

## Endpoints

1. **Health Check**:
   ```
   GET /health
   ```
   Returns a simple message to confirm the API is running.

2. **Search**:
   ```
   GET /search?user_id=<user_id>&text=<search_text>&top_k=<top_k>&threshold=<threshold>
   ```
   Parameters:
   - `user_id`: (Required) Unique identifier for the user making the request.
   - `text`: (Required) Search query to find relevant documents.
   - `top_k`: (Optional) Number of top results to return (default: 5).
   - `threshold`: (Optional) Minimum similarity score threshold (default: 0.2).

   Responses are cached for faster retrieval.

3. **Rate Limiting**:
   - If a user exceeds 5 requests, the API will return a **429 Too Many Requests** status code.

## Caching Strategy

The system uses **Redis** for caching both document embeddings and search responses. Redis was chosen over alternatives like Memcached for the following reasons:
- **Persistence**: Redis supports data persistence, which is important to ensure cached data survives server restarts.
- **Advanced Data Structures**: Redis offers more than simple key-value storage, making it a versatile option for caching search results and other data.
- **Expiration Control**: Redis allows fine-grained control over cache expiration times, which ensures optimal performance and freshness of data.

## Installation

1. **Clone the repository**:
   ```
   git clone https://github.com/your-username/your-repo-name.git
   cd your-repo-name
   ```

2. **Install dependencies**:
   ```
   pip install -r requirements.txt
   ```

3. **Set up environment variables**:
   Create a `.env` file and add the necessary API keys:
   ```
   PINECONE_API_KEY=your_pinecone_api_key
   GROQ_API_KEY=your_groq_api_key
   ```

4. **Run Redis**:
   Make sure Redis is installed and running on `localhost:6379`.

5. **Run the application**:
   ```
   python main.py
   ```

6. **Dockerize the application**:
   To build and run the Docker container:
   ```
   docker build -t document-retrieval .
   docker run -p 5000:5000 document-retrieval
   ```

## Usage

- **Scrape News and Store Embeddings**:
  The system starts scraping news and generating embeddings in the background upon server startup.
  
- **Run the API**:
  You can interact with the API at `http://localhost:5000`.

## Database

- **User Tracking**: The system uses an SQLite database (`api_calls.db`) to store user request counts. For each search request, the count is incremented. If the user exceeds 5 requests, the API returns a 429 status code.

## Requirements

- Python 3.7+
- Redis
- Pinecone
- Flask
- Docker

## Dependencies

The required Python packages are listed in `requirements.txt`. Key dependencies include:
- `requests`
- `beautifulsoup4`
- `redis`
- `langchain_text_splitters`
- `pinecone`
- `flask`
- `dotenv`

