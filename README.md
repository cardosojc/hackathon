# Hackathon - Ollama LLM with pgvector

Docker setup for running Ollama LLM with pgvector database. Includes llama3.2:3b for text generation and nomic-embed-text for embeddings.

## Quick Start

### Option 1: Using Docker Hub Image (Recommended)

Pull and run the pre-built Ollama image with the llama3.2:3b model:

```bash
docker pull cardosoj/ollama-llama3.2:latest
docker-compose up -d
```

### Option 2: Build from Dockerfile

```bash
docker-compose up -d
```

This will:
- Start the Ollama server on port 11434
- Load llama3.2:3b model (text generation)
- Load nomic-embed-text model (embeddings)
- Start PostgreSQL with pgvector extension on port 5432

## Services

### Ollama
- **Port**: 11434
- **Models**:
  - llama3.2:3b (text generation)
  - nomic-embed-text (embeddings)
- **Image**: cardosoj/ollama-llama3.2:latest

### PostgreSQL with pgvector
- **Port**: 5432
- **Database**: vectordb
- **User**: postgres
- **Password**: postgres

## Usage

### Text Generation

Test the Ollama API with llama3.2:3b:
```bash
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2:3b",
  "prompt": "Hello, how are you?"
}'
```

### Generate Embeddings

Generate embeddings using nomic-embed-text:
```bash
curl http://localhost:11434/api/embeddings -d '{
  "model": "nomic-embed-text",
  "prompt": "Your text here"
}'
```

### PostgreSQL with pgvector

Connect to PostgreSQL:
```bash
psql -h localhost -U postgres -d vectordb
```

## Docker Hub

The pre-built Ollama image with both models (llama3.2:3b and nomic-embed-text) is available at:
https://hub.docker.com/r/cardosoj/ollama-llama3.2
