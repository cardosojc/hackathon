# Hackathon - Local LLM with Ollama + pgvector

Run a complete AI development environment locally with **Ollama** (LLM), **PostgreSQL + pgvector** (vector database), and **Jupyter Lab** (notebooks).

---

##  Prerequisites

Before you begin, make sure you have:

- [Docker](https://docs.docker.com/get-docker/) installed and running
- [Docker Compose](https://docs.docker.com/compose/install/) (usually included with Docker Desktop)
- At least **8GB of free disk space** (for models)
- At least **8GB of RAM** recommended

Verify your installation:

```bash
docker --version
docker compose version
```

---

## ⚡ Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/cardosojc/hackathon.git
cd hackathon

# 2. Start all services
docker compose -f docker-compose.yml up -d

# 3. Wait for Ollama to start (~30 seconds), then download models
docker exec ollama ollama pull llama3.2:3b
docker exec ollama ollama pull nomic-embed-text

# 4. Open Jupyter Lab
# Go to: http://localhost:8888?token=hackathon
```

---

## Step-by-Step Guide

### Step 1: Clone the Repository

```bash
git clone https://github.com/cardosojc/hackathon.git
cd hackathon
```

### Step 2: Start Docker Containers

```bash
docker compose -f docker-compose.yml up -d
```

You should see:

```
✔ Container ollama            Started
✔ Container postgres-pgvector Started
✔ Container jupyter           Started
```

### Step 3: Verify Containers are Running

```bash
docker ps
```

Expected output:

```
CONTAINER ID   IMAGE                    STATUS         PORTS
xxxx           ollama/ollama:latest     Up 2 minutes   0.0.0.0:11434->11434/tcp
xxxx           pgvector/pgvector:pg16   Up 2 minutes   0.0.0.0:5432->5432/tcp
xxxx           python:3.11-slim         Up 2 minutes   0.0.0.0:8888->8888/tcp
```

### Step 4: Download Ollama Models

Wait ~30 seconds for Ollama to initialize, then:

```bash
# Download the LLM model (for text generation)
docker exec ollama ollama pull llama3.2:3b

# Download the embedding model (for vector search)
docker exec ollama ollama pull nomic-embed-text
```

>  **Note:** The first download may take several minutes depending on your internet speed.

### Step 5: Verify Models

```bash
docker exec ollama ollama list
```

Expected output:

```
NAME                    SIZE
llama3.2:3b             2.0 GB
nomic-embed-text        274 MB
```

### Step 6: Access Jupyter Lab

Open your browser and go to:

```
http://localhost:8888/lab?token=hackathon
```

Your notebooks will be in the root folder (`/home/work`).

---

##  Accessing Services

| Service | URL | Credentials |
|---------|-----|-------------|
| **Jupyter Lab** | http://localhost:8888 | Token: `hackathon` |
| **Ollama API** | http://localhost:11434 | - |
| **PostgreSQL** | localhost:5432 | User: `postgres` / Pass: `postgres` / DB: `vectordb` |

---

##  Running the Notebook

### Important: Configure Ollama Host

Since the notebook runs **inside Docker**, you need to use the container name instead of `localhost`:

```python
import ollama

# CORRECT - Use container name
client = ollama.Client(host='http://ollama:11434')

#  WRONG - Won't work inside Docker
# client = ollama.Client(host='http://localhost:11434')
```

### Example: Chat with the Model

```python
import ollama

client = ollama.Client(host='http://ollama:11434')

MODEL = "llama3.2:3b"

def chat(msg):
    resp = client.chat(model=MODEL, messages=[{"role": "user", "content": msg}])
    return resp["message"]["content"]

# Test it
print(chat("What is Docker in one sentence?"))
```

### Example: Generate Embeddings

```python
import ollama

client = ollama.Client(host='http://ollama:11434')

def get_embedding(text):
    response = client.embeddings(model='nomic-embed-text', prompt=text)
    return response['embedding']

# Test it
embedding = get_embedding("Hello world")
print(f"Embedding dimension: {len(embedding)}")
```

### Example: Connect to PostgreSQL

```python
import psycopg2

conn = psycopg2.connect(
    host="postgres-pgvector",  # Container name, not localhost!
    port=5432,
    database="vectordb",
    user="postgres",
    password="postgres"
)

cur = conn.cursor()
cur.execute("SELECT version();")
print(cur.fetchone())
```

---

## Managing Ollama Models (in case you want to change the model/work with a new one!)

### List Installed Models

```python
client = ollama.Client(host='http://ollama:11434')
models = client.list()

for model in models['models']:
    print(f"- {model['name']}")
```

### Download New Models

```python
# From notebook
client.pull('mistral:7b')
```

Or from terminal:

```bash
docker exec ollama ollama pull mistral:7b
```

### Popular Models

| Model | Size | Best For |
|-------|------|----------|
| `llama3.2:1b` | ~1.3GB | Fast responses, limited resources |
| `llama3.2:3b` | ~2GB | Good balance of speed/quality |
| `mistral:7b` | ~4GB | High quality responses |
| `codellama:7b` | ~4GB | Code generation |
| `nomic-embed-text` | ~274MB | Text embeddings |

### Delete a Model

```bash
docker exec ollama ollama rm model-name
```

---

##  Useful Commands

### Container Management

```bash
# Start all services
docker compose -f docker-compose-v2.yml up -d

# Stop all services
docker compose -f docker-compose-v2.yml down

# Restart all services
docker compose -f docker-compose-v2.yml restart

# View logs (all services)
docker compose -f docker-compose-v2.yml logs -f

# View logs (specific service)
docker logs -f ollama
docker logs -f jupyter
docker logs -f postgres-pgvector
```

### Testing Ollama API

```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# Test text generation
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2:3b",
  "prompt": "Hello!",
  "stream": false
}'

# Test embeddings
curl http://localhost:11434/api/embeddings -d '{
  "model": "nomic-embed-text",
  "prompt": "Test embedding"
}'
```

### Clean Up

```bash
# Stop and remove containers
docker compose -f docker-compose-v2.yml down

# Stop, remove containers AND delete volumes (models, database)
docker compose -f docker-compose-v2.yml down -v

# Remove all unused Docker resources
docker system prune -a
```