FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy files
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

# Expose the HTTP API port (FastAPI)
EXPOSE 8080

# Run the proxy
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
