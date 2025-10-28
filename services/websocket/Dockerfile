# websocket Dockerfile

FROM python:3.10-slim

WORKDIR /usr/src/chat-app

# Install system dependencies including netcat
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    netcat-traditional \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Make entrypoint executable
RUN chmod +x entrypoint_socket.sh

# Expose port
EXPOSE 5001

# Set entrypoint
ENTRYPOINT ["sh", "/usr/src/chat-app/entrypoint_socket.sh"]