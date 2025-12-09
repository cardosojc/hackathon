FROM ollama/ollama

ENV OLLAMA_HOST="0.0.0.0"

RUN nohup ollama serve & sleep 5 && \
    ollama pull llama3.2:3b && \
    ollama pull nomic-embed-text
