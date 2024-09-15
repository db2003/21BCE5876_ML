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
