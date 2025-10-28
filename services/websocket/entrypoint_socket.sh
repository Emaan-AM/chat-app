#!/bin/sh

echo "================================================"
echo "🚀 Starting ChatApp WebSocket Server"
echo "================================================"

echo "⏳ Waiting for PostgreSQL..."
while ! nc -z db 5432; do
  sleep 0.1
done
echo "✅ PostgreSQL is ready"

echo "⏳ Waiting for Redis..."
while ! nc -z redis 6379; do
  sleep 0.1
done
echo "✅ Redis is ready"

echo "🌐 Starting WebSocket server..."
python manage_socket.py run -h 0.0.0.0