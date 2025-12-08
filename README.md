# Hackathon - Ollama LLM with pgvector

Docker setup for running Ollama LLM (llama3.2:3b model) with pgvector database.

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
- Pull the llama3.2:3b model
- Start PostgreSQL with pgvector extension on port 5432

## Services

### Ollama
- **Port**: 11434
- **Model**: llama3.2:3b
- **Image**: cardosoj/ollama-llama3.2:latest

### PostgreSQL with pgvector
- **Port**: 5432
- **Database**: vectordb
- **User**: postgres
- **Password**: postgres

## Usage

Test the Ollama API:
```bash
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2:3b",
  "prompt": "Hello, how are you?"
}'
```

Connect to PostgreSQL:
```bash
psql -h localhost -U postgres -d vectordb
```

## Docker Hub

The pre-built Ollama image with llama3.2:3b model is available at:
https://hub.docker.com/r/cardosoj/ollama-llama3.2
