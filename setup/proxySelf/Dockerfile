FROM python:3.11-slim AS fastapi-builder

# Install fastAPI and dependencies
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY main.py .

# Expose the HTTP API port (FastAPI) --> check later how to optimise
EXPOSE 8080 50050 50051 50052 

# Second stage: base NGINX + python
FROM nginx:stable

# Install NGINX and python runtime
RUN apt-get update && \
    apt-get install -y nginx python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*
    
# Copy fastAPI files from builder
COPY --from=fastapi-builder /app /app
WORKDIR /app

# Copy NGINX config
#COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Install python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --break-system-packages -r requirements.txt

# Run the proxy
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port 8080 & nginx -g 'daemon off;'"]
