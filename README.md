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

The system uses **Redis** for caching both document embeddings and search responses. 

## Installation

1. **Clone the repository**:
   ```
   git clone https://github.com/your-username/21BCE5876_ML.git
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

6. ## **Dockerisation**:
<img src="https://github.com/user-attachments/assets/ae8799c9-b318-4275-8b2c-6077c0bf2ba6" width="900" height="600" alt="Docker_Tool">


The application is fully Dockerized for easy deployment. Follow these steps to build and run the application using Docker:

### Steps to Dockerize the Application

1. **Create a `Dockerfile`**:
   The Dockerfile defines the environment and dependencies required to run the application. Here's the `Dockerfile` used in this project:

   ```
   # Use Python 3.11 to avoid the python-magic-bin compatibility issue
   FROM python:3.11-slim

   # Set the working directory in the container
   WORKDIR /app

   # Copy the requirements file into the container
     COPY requirements.txt .

    # Install required Python packages
    RUN pip install --no-cache-dir -r requirements.txt

    # Install Redis server for caching
    RUN apt-get update && apt-get install -y redis-server

     # Copy the project files into the container
    COPY . .

     # Expose the port that the Flask app will run on
     EXPOSE 5000

     # Start Redis and the Flask app
    CMD service redis-server start && python main.py

   ```

2. **Docker Compose Setup**:
   This Project uses **Redis** for caching, Docker Compose makes it easy to define and run the Redis service alongside the application.

   Create a `docker-compose.yml` file:

   ```
    version: '3'
   services:
    app:
    build: .
    ports:
      - "5000:5000"  # Host port 5000 -> Container port 5000
    volumes:
      - .:/app
    environment:
      - FLASK_ENV=development
    depends_on:
      - redis
    command: python main.py

    redis:
    image: redis:alpine
    ports:
      - "6379:6379"  # Expose Redis on port 6379

   ```

3. **Build and Run the Docker Containers**:

   To build the Docker image and start the application with Redis, use the following commands:

   ```
   docker-compose build
   docker-compose up
   ```
   or 
   ```
   docker-compose up --build
   ```

   The application will now be running on `http://localhost:5000`, and Redis will be available at `localhost:6379` for caching.

4. **Running the Application**:

   Once the containers are up, you can access the following functionalities:
   **We input the user_id, threshold and query in the url itself as shown below and some example images also given**

   - **Health Check**: ` http://localhost:5000/health`
   - **Search API**: ` http://localhost:5000/search?user_id=<user_id>&text=<search_text>&top_k=<top_k>&threshold=<threshold>`

   The application logs request details and tracks user requests in the SQLite database (`api_calls.db`). If the same query is made, cached results are served to minimize inference time. 

5. **Stop the Docker Containers**:

   When you're done, you can stop the running containers by presing CTRL+C or using:

   ```
   docker-compose down
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

## Working

### Health Check:
<img src="https://github.com/user-attachments/assets/d2492ae9-0613-4c30-9953-0ef851612455" width="600" height="200" alt="Health Check">

### Example Query:
<img src="https://github.com/user-attachments/assets/ee6522e9-8849-43ee-9e00-4af7181b58ea" width="2200" height="200" alt="Example Query">
Different k value:
<img src="https://github.com/user-attachments/assets/e18d0d81-1a05-4757-b8e5-c0bd45665cfb" width="2300" height="200" alt="K Value 10">

### Too Many Requests by Same User:
<img src="https://github.com/user-attachments/assets/06dd2d1c-98cb-487c-9082-3b7d6be223e6" width="2200" height="200" alt="Too Many Requests">
<img src="https://github.com/user-attachments/assets/ed22a1b9-514a-441c-abbc-13ecdda17854" width="2200" height="200" alt="Too Many Requests">

 **Error 429:**
<img src="https://github.com/user-attachments/assets/783bb094-82dc-4614-988e-5bf4ac71ec1e" width="2200" height="200" alt="Too Many Requests">

### Caching Example: 
- if user13 asks for a query "give a small summary of your latest retreived article"

<img src="https://github.com/user-attachments/assets/7fb59190-beca-42c0-b841-41abc5b14a6d" width="2200" height="200" alt="caching_org">

- if the same query is asked by the same or other person:

<img src="https://github.com/user-attachments/assets/81c65d66-115b-414a-9832-4fe57144ed42" width="2200" height="200" alt="Cachingex">
- we can see inference time is LARGELY reduced due to caching.



### Docker ScreenShots:
![image](https://github.com/user-attachments/assets/c2d3993c-2c47-444d-92e8-fe893d3dff03)

![image](https://github.com/user-attachments/assets/f047dd20-054c-43b0-8093-d4993c168d16)

This setup ensures that your application is scalable, easily deployable, and leverages Docker to manage dependencies and services efficiently.
