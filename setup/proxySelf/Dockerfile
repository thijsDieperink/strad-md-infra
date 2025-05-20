FROM python:3.11-slim as fastAPI-builder

# Install fastAPI and dependencies
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY main.py .

# Expose the HTTP API port (FastAPI)
EXPOSE 8080

# Second stage: base NGINX + python
FROM debian:bullseye-slim

# Install NGINX and python runtime
RUN apt-get update && \
    apt-get install -y nginx python3 python3-pip && \
    rm -rg /var/lib/apt/lists/*
    
# Copy fastAPI files from builder
COPY --from=fastAPI-builder /app /app
WORKDIR /app

# Copy NGINX config
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Install python dependencies
COPY requirements.txt .
RUN pip3 install --no-cache -dir -r requirements.txt

# Run the proxy
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port 8080 & nginx -g 'daemon off;'"]
