#!/bin/sh

echo "================================================"
echo "🚀 Starting ChatApp Backend"
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

echo "🔄 Running Alembic database migrations..."
cd /usr/src/chat-app

# Check if alembic is initialized
if [ -d "alembic" ]; then
    alembic upgrade head
    echo "✅ Database migrations completed"
else
    echo "⚠️  Alembic not initialized. Skipping migrations."
fi

echo "🌐 Starting Flask application..."
python manage.py run -h 0.0.0.0