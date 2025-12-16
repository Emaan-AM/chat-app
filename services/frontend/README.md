# Chat Application - DevOps Final Project

## Project Overview

A **real-time chat application** built with modern microservices architecture, demonstrating comprehensive DevOps practices including containerization, infrastructure as code, orchestration, CI/CD, and monitoring.

### Architecture Components

- **Frontend**: React.js (port 3000)
- **Backend API**: Flask/Python (port 5000)
- **WebSocket Service**: Flask-SocketIO (port 5001)
- **Database**: PostgreSQL 15 (port 5432)
- **Cache/Queue**: Redis 7 (port 6379)

---

## 🎯 Project Objectives Achieved

✅ Containerized multi-service application with Docker  
✅ Infrastructure provisioned with Terraform on AWS  
✅ Kubernetes deployment (EC2)  
✅ Configuration management with Ansible  
✅ CI/CD pipeline with GitHub Actions  
✅ Monitoring with Prometheus & Grafana  
✅ Production-ready DevOps stack  

## 💻 Running Locally

### Method 1: Docker Compose (Recommended)

1. **Clone the repository**
```bash
git clone https://github.com/Emaan-AM/chat-app.git
cd chat-app
```

2. **Configure environment variables**
```bash
cp .env.example .env
```

3. **Start all services**
```bash
docker-compose up -d
```

4. **Verify services are running**
```bash
docker-compose ps
```

5. **Access the application**
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000
- WebSocket: http://localhost:5001

6. **View logs**
```bash
docker-compose logs -f
docker-compose logs -f backend
```

7. **Stop services**
```bash
docker-compose down
```

### Method 2: Local Development

**Frontend:**
```bash
cd services/frontend
npm install
npm start
```

**Backend:**
```bash
cd services/backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
```

**Database:**
```bash
docker run -d \
  -p 5432:5432 \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=verysecurepassword \
  -e POSTGRES_DB=chatdb \
  postgres:15-alpine
```

**Redis:**
```bash
docker run -d -p 6379:6379 redis:7-alpine
```

---

## ☸️ Kubernetes Deployment

### Local Kubernetes (Minikube)

1. **Start Minikube**
```bash
minikube start --cpus=4 --memory=8192
```

2. **Load Docker images** (if building locally)
```bash
eval $(minikube docker-env)
docker-compose build
```

3. **Create namespace**
```bash
kubectl create namespace chat-app-dev
```

4. **Apply manifests**
```bash
# Secrets first
kubectl apply -f k8s/secrets/ -n chat-app-dev

# ConfigMaps
kubectl apply -f k8s/configmaps/ -n chat-app-dev

# Deployments
kubectl apply -f k8s/deployments/ -n chat-app-dev

# Services
kubectl apply -f k8s/services/ -n chat-app-dev

# Ingress (optional)
kubectl apply -f k8s/ingress/ -n chat-app-dev
```

5. **Verify deployment**
```bash
kubectl get pods -n chat-app-dev
kubectl get services -n chat-app-dev
kubectl describe pod <pod-name> -n chat-app-dev
```

6. **Access the application**
```bash
# Get Minikube IP
minikube ip

# Port forward (alternative)
kubectl port-forward svc/frontend-service 3000:3000 -n chat-app-dev
```

## 🏗️ Infrastructure Setup (Terraform)

### Prerequisites
- AWS account with appropriate permissions
- AWS CLI configured (`aws configure`)
- Terraform installed

### Provision Infrastructure

1. **Navigate to infra directory**
```bash
cd infra
```

2. **Initialize Terraform**
```bash
terraform init
```

3. **Review planned changes**
```bash
terraform plan
```

4. **Apply infrastructure**
```bash
terraform apply

# Auto-approve (use with caution)
terraform apply -auto-approve
```

5. **View outputs**
```bash
terraform output
```

### Infrastructure Components Provisioned

- **VPC**: Custom VPC with public/private subnets across 2 AZs
- **EC2 Cluster**: Managed Kubernetes cluster with node groups
- **RDS PostgreSQL**: Managed database instance
- **ElastiCache Redis**: Managed Redis cluster
- **Security Groups**: Properly configured firewall rules
- **IAM Roles**: For cluster and worker nodes

### Teardown Infrastructure

⚠️ **Warning**: This will destroy all resources!

```bash
cd infra
terraform destroy

# Auto-approve (use with caution)
terraform destroy -auto-approve
```

**Verify cleanup:**
```bash
# Check AWS Console or use CLI
aws ec2 list-clusters --region us-east-1
aws rds describe-db-instances --region us-east-1
```

---

## ⚙️ Configuration Management (Ansible)

### Setup

1. **Install Ansible**
```bash
pip install ansible boto3
```

2. **Configure AWS credentials**
```bash
export AWS_ACCESS_KEY_ID=your_key
export AWS_SECRET_ACCESS_KEY=your_secret
export AWS_REGION=us-east-1
```

### Run Playbook

1. **Update inventory**
```bash
cd ansible
# Edit inventory/hosts.ini with your EC2 IPs
```

2. **Test connection**
```bash
ansible all -i inventory/hosts.ini -m ping
```

3. **Run full playbook**
```bash
ansible-playbook -i inventory/hosts.ini playbook.yml

# With verbose output
ansible-playbook -i inventory/hosts.ini playbook.yml -vvv

# Specific tags
ansible-playbook -i inventory/hosts.ini playbook.yml --tags "docker,kubernetes"
```

4. **Dynamic inventory (AWS EC2)**
```bash
ansible-playbook -i inventory/aws_ec2.yml playbook.yml
```

### What Ansible Configures

- Docker installation on nodes
- Kubernetes dependencies
- Application configuration files
- Secret management
- Service deployment

---

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

The pipeline automatically triggers on:
- Push to `main` or `develop` branches
- Pull requests to `main`

### Pipeline Stages

1. **Build & Test**
   - Lint code
   - Run unit tests
   - Build Docker images

2. **Security Scanning**
   - Trivy container scanning
   - Secret detection
   - Dependency vulnerability check

3. **Docker Build & Push**
   - Build multistage images
   - Tag with commit SHA
   - Push to registry

4. **Infrastructure Provision**
   - Run `terraform plan`
   - Apply infrastructure (on main branch)

5. **Deploy to Kubernetes**
   - Update image tags
   - Apply manifests via kubectl
   - Run Ansible playbooks

6. **Post-Deploy Tests**
   - Health checks
   - Smoke tests
   - Integration tests

### Manual Workflow Trigger

```bash
# Via GitHub CLI
gh workflow run main.yml

# Via GitHub Web Interface
Actions → Select workflow → Run workflow
```

### View Pipeline Status

```bash
gh run list
gh run view <run-id>
gh run watch
```

---

## 📊 Monitoring & Observability

### Prometheus Setup

1. **Deploy Prometheus**
```bash
kubectl apply -f monitoring/prometheus/
```

2. **Access Prometheus UI**
```bash
kubectl port-forward svc/prometheus 9090:9090 -n monitoring
```

Visit: http://localhost:9090

### Grafana Setup

1. **Deploy Grafana**
```bash
kubectl apply -f monitoring/grafana/
```

2. **Access Grafana**
```bash
kubectl port-forward svc/grafana 3001:3000 -n monitoring
```

Visit: http://localhost:3001

**Default credentials:**
- Username: `admin`
- Password: Check secret or `kubectl get secret grafana-admin -n monitoring -o jsonpath='{.data.password}' | base64 -d`

3. **Add Prometheus data source**
- URL: `http://prometheus:9090`
- Access: Server (default)

4. **Import dashboards**
- Kubernetes Cluster Monitoring (ID: 315)
- Node Exporter Full (ID: 1860)
- Custom application metrics

### Key Metrics Monitored

- **Infrastructure**: CPU, Memory, Disk, Network
- **Application**: Request rate, Error rate, Latency
- **Database**: Connections, Query performance
- **Redis**: Hit rate, Memory usage
- **Kubernetes**: Pod status, Resource usage

---

## 🔐 Security & Secrets Management

### Environment Variables

**Never commit sensitive data!** Use `.env` files locally:

```bash
cp .env.example .env
# Edit .env with your credentials
```

### Kubernetes Secrets

Create secrets from files:
```bash
kubectl create secret generic app-secrets \
  --from-file=.env \
  -n chat-app-dev
```

Create secrets from literals:
```bash
kubectl create secret generic db-credentials \
  --from-literal=username=admin \
  --from-literal=password=securepass \
  -n chat-app-dev
```

### AWS Secrets Manager (Production)

Secrets are stored in AWS Secrets Manager and accessed via:
- IAM roles
- External Secrets Operator
- Application code with AWS SDK

---

## 🧪 Testing

### Run Tests

**Backend:**
```bash
cd services/backend
pytest tests/
```

**Frontend:**
```bash
cd services/frontend
npm test
```

**Integration Tests:**
```bash
docker-compose up -d
pytest tests/integration/
docker-compose down
```

---

## 🐛 Troubleshooting

### Docker Compose Issues

**Problem**: Services won't start
```bash
# Check logs
docker-compose logs

# Rebuild images
docker-compose build --no-cache

# Clean volumes
docker-compose down -v
```

**Problem**: Port already in use
```bash
# Find process using port
lsof -i :5000
# Kill process or change port in docker-compose.yml
```

### Kubernetes Issues

**Problem**: Pods not starting
```bash
# Check pod status
kubectl describe pod <pod-name> -n chat-app-dev

# Check events
kubectl get events -n chat-app-dev --sort-by='.lastTimestamp'

# Check logs
kubectl logs <pod-name> -n chat-app-dev
```

**Problem**: Service not accessible
```bash
# Check service
kubectl get svc -n chat-app-dev

# Test from another pod
kubectl run -it --rm debug --image=alpine --restart=Never -n chat-app-dev -- sh
# Inside pod: wget -O- http://backend-service:5000/health
```

### Terraform Issues

**Problem**: State locked
```bash
# Force unlock (use carefully)
terraform force-unlock <lock-id>
```

**Problem**: Resource already exists
```bash
# Import existing resource
terraform import aws_vpc.main vpc-xxxxx
```

---

## 👥 Team Members

- **Khadijah Hasan**: AWS Terraform & CI/CD
- **Emaan Mueed**: Ansible & Prometheus
- **Esha Alvi**: Kubernetes, Grafana & Documentation


## 🙏 Acknowledgments

- Course: CSC418 - DevOps
- Section: G1, Batch FA22
- Instructor: Dr. Muhammad Hasan Jamal
- University: COMSATS

---

**Last Updated**: December 16, 2025