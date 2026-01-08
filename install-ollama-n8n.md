docker run -d -v ollama:/root/.ollama --name ollama-n8n --network red-n8n-ollama -p 11500:11434 ollama/ollama:latest
docker run -d -v n8n_data:/home/node/.n8n --name n8n --network red-n8n-ollama -p 5678:5678 n8nio/n8n
