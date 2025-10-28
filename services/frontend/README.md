# ChatApp

ChatApp is a real-time messaging application with a modern frontend, backend, and database architecture, containerized using Docker and automated via a CI/CD pipeline.

---

## **Features**

- Real-time messaging via WebSockets
- Persistent storage using PostgreSQL
- Redis caching support (optional)
- Containerized with Docker Compose
- Automated CI/CD workflow with GitHub Actions
- Environment configuration using `.env` and secrets management

---

## **Project Structure**

```
chat-app/
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── Messages.jsx
│   │   │   └── TextField.jsx
│   │   ├── App.js
│   │   ├── App.test.js
│   │   └── setupTests.js
│   ├── package.json
│   ├── .env
│   └── Dockerfile
│
├── backend/
│   ├── app/
│   │   ├── api/
│   │   └── __init__.py
│   ├── helper/
│   │   ├── crud.py
│   │   └── models.py
│   ├── tests/
│   ├── Dockerfile
│   └── requirements.txt
│
├── websocket/
│   ├── app/
│   ├── tests/
│   ├── Dockerfile
│   └── requirements.txt
│
├── docker-compose.yml
├── .env
└── README.md
```

---

## **Setup & Run**

### **1. Clone the Repository**

```bash
git clone https://github.com/Emaan-AM/chat-app.git
cd chat-app
```

### **2. Build and Run with Docker Compose**

```bash
docker-compose up --build
```

The application will be available at:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5004
- **WebSocket**: http://localhost:5001

### **3. Initialize the Database**

```bash
docker-compose exec backend python manage.py reset_db
```

---

## **Running Tests**

### **Backend**

```bash
cd backend
pytest
```

Or using Docker:

```bash
docker-compose exec backend pytest
```

### **WebSocket**

```bash
cd websocket
pytest
```

Or using Docker:

```bash
docker-compose exec websocket pytest
```

### **Frontend**

```bash
cd frontend
npm install
npm test
```

Or using Docker:

```bash
docker-compose exec frontend npm test
```

---

## **CI/CD Pipeline**

The CI/CD pipeline is triggered on **push** or **pull request** to `main` or `develop` branches.

**Pipeline runs on**: Ubuntu GitHub Actions runner

### **Pipeline Stages**

1. **Build & Install**: Installs Python and Node.js dependencies
2. **Lint/Security Scan**: Runs linters and optional security checks
3. **Test**: Executes backend (pytest) and frontend tests
4. **Build Docker Images**: Builds backend, frontend, and websocket images
5. **Conditional Deploy**: Pushes images to Docker Hub if:
   - Branch is `main`
   - All tests pass

### **Workflow File**

The workflow configuration is located at `.github/workflows/ci-cd.yml`

---

## **Docker Images**

Pre-built Docker Hub images are available:

- `emaan123/chat-app-backend:latest`
- `emaan123/chat-app-websocket:latest`
- `emaan123/chat-app-frontend:latest`

**Pull images:**

```bash
docker pull emaan123/chat-app-backend:latest
docker pull emaan123/chat-app-websocket:latest
docker pull emaan123/chat-app-frontend:latest
```

**Local builds** are supported via Docker Compose context.

---

## **API Endpoints**

### **Backend REST API** (Port 5004)

| Method | Endpoint    | Description              |
|--------|-------------|--------------------------|
| GET    | `/ping`     | Health check             |
| GET    | `/messages` | Retrieve all messages    |
| POST   | `/messages` | Create a new message     |


### **WebSocket** (Port 5001)

Real-time message broadcasting via Socket.IO

---

## **Troubleshooting**

### **Containers not starting**

```bash
# Check container status
docker-compose ps

# View logs
docker-compose logs backend
docker-compose logs websocket
docker-compose logs frontend
```

### **Database connection issues**

```bash
# Reset the database
docker-compose exec backend python manage.py reset_db

# Verify database is running
docker-compose exec db psql -U postgres -d chatapp_db -c "\dt"
```

### **Frontend can't connect to backend**

Ensure your `.env` file uses `localhost` (not internal Docker service names) for frontend environment variables:

```bash
REACT_APP_BACKEND_SERVICE_URL=http://localhost:5004
REACT_APP_WEBSOCKET_SERVICE_URL=http://localhost:5001
```

---

## **Additional Notes**

- **Secrets Management**: Secrets are never committed to Git; they are loaded via CI/CD from GitHub Secrets or a `.env` file in local development
- **Redis**: Can be optionally added for caching to improve performance
- **Database Migrations**: Alembic is used for database migrations to ensure schema consistency
- **Development Mode**: Hot-reloading is enabled for both frontend and backend in development

---

## **Tech Stack**

| Component    | Technology                |
|--------------|---------------------------|
| Frontend     | React, Socket.IO Client   |
| Backend      | Flask, Flask-RESTX        |
| WebSocket    | Flask-SocketIO            |
| Database     | PostgreSQL 15             |
| Caching      | Redis (optional)          |
| Container    | Docker, Docker Compose    |
| CI/CD        | GitHub Actions            |

---

## **Contributing**

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

**Repository**: https://github.com/Emaan-AM/chat-app