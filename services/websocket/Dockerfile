# Use a newer, supported Python image
FROM python:3.9-slim

# Set working directory
WORKDIR /usr/src/chat-app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
# (libpq-dev is required for psycopg2 / PostgreSQL support)
RUN apt-get update \
    && apt-get -y install netcat-openbsd gcc libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add and install Python requirements
COPY ./requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Add entrypoint script
COPY ./entrypoint_socket.sh /usr/src/chat-app/entrypoint_socket.sh
RUN chmod +x /usr/src/chat-app/entrypoint_socket.sh

# Copy the rest of the application
COPY . .

# Default entrypoint
ENTRYPOINT ["sh", "/usr/src/chat-app/entrypoint_socket.sh"]
