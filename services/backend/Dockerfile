FROM python:3.9-slim

WORKDIR /usr/src/chat-app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get -y install netcat-openbsd gcc libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

COPY ./entrypoint.sh /usr/src/chat-app/entrypoint.sh
RUN chmod +x /usr/src/chat-app/entrypoint.sh

COPY . .

ENTRYPOINT ["sh", "/usr/src/chat-app/entrypoint.sh"]
