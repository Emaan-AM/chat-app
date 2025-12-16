# DevOps Implementation Report
## Chat Application - Production-Ready Stack

**Course**: CSC418 - DevOps Engineering  
**Section**: G1, Batch FA22  
**Date**: December 16, 2025  
**Project Type**: Final Exam - Group Project (3 Members)

---

## Executive Summary

This report documents the complete DevOps implementation for a real-time chat application, demonstrating enterprise-grade practices across containerization, infrastructure automation, orchestration, CI/CD, and monitoring. The project successfully delivers a production-ready stack deployed on AWS with full observability.

### Key Achievements
- ✅ 100% containerized microservices architecture
- ✅ Fully automated infrastructure provisioning (Terraform)
- ✅ Kubernetes-orchestrated deployment on AWS
- ✅ Automated CI/CD pipeline with 6 stages
- ✅ Comprehensive monitoring with Prometheus & Grafana
- ✅ Zero-downtime deployments with rolling updates
- ✅ Enterprise-grade security with secrets management

---

## 1. Technology Stack

### Application Layer
| Component   | Technology     | Version | Purpose                 |
|-------------|----------------|---------|-------------------------|
| Frontend    | React.js       | 18.2.0  | User interface          |
| Backend API | Flask          | 3.0.0   | REST API server         |
| WebSocket   | Flask-SocketIO | 5.3.0   | Real-time messaging     |
| Database    | PostgreSQL     | 15.0    | Persistent storage      |
| Cache/Queue | Redis          | 7.0     | Session & message queue |

### DevOps Tools
| Category                 | Technology     | Version | Purpose               |
|--------------------------|----------------|---------|-----------------------|
| Containerization         | Docker         | 24.0+   | Application packaging |
| Container Orchestration  | Kubernetes     | 1.28    | Service management    |
| Infrastructure as Code   | Terraform      | 1.5+    | AWS provisioning      |
| Configuration Management | Ansible        | 2.15+   | Server configuration  |
| CI/CD                    | GitHub Actions | -       | Automated pipeline    |
| Monitoring               | Prometheus     | 2.45+   | Metrics collection    |
| Visualization            | Grafana        | 10.0+   | Dashboard & alerts    |
| Container Registry       | Docker Hub     | -       | Image storage         |

### Cloud Infrastructure (AWS)
- **Compute**: EC2
- **Database**: RDS PostgreSQL
- **Cache**: ElastiCache Redis
- **Networking**: VPC, Subnets, Security Groups, Load Balancers
- **IAM**: Roles and policies for EC2
- **Secrets**: AWS Secrets Manager

---

## 2. Architecture Overview

### 2.1 Application Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         AWS Cloud                           │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                    VPC (10.0.0.0/16)                  │  │
│  │                                                       │  │
│  │  ┌──────────────┐         ┌──────────────┐            │  │
│  │  │ Public Subnet│         │ Public Subnet│            │  │
│  │  │  (AZ-1a)     │         │  (AZ-1b)     │            │  │
│  │  │              │         │              │            │  │
│  │  │  ┌────────┐  │         │  ┌────────┐  │            │  │
│  │  │  │  ALB   │  │         │  │  ALB   │  │            │  │
│  │  │  └───┬────┘  │         │  └───┬────┘  │            │  │
│  │  └──────┼───────┘         └──────┼───────┘            │  │
│  │         │                        │                    │  │
│  │  ┌──────┴────────────────────────┴────────┐           │  │
│  │  │             Cluster                    │           │  │
│  │  │  ┌──────────┐  ┌──────────┐            │           │  │
│  │  │  │ Frontend │  │ Frontend │            │           │  │
│  │  │  │   Pod    │  │   Pod    │            │           │  │
│  │  │  └──────────┘  └──────────┘            │           │  │
│  │  │  ┌──────────┐  ┌──────────┐            │           │  │
│  │  │  │ Backend  │  │ Backend  │            │           │  │
│  │  │  │   Pod    │  │   Pod    │            │           │  │
│  │  │  └──────────┘  └──────────┘            │           │  │
│  │  │  ┌──────────┐  ┌──────────┐            │           │  │
│  │  │  │WebSocket │  │WebSocket │            │           │  │
│  │  │  │   Pod    │  │   Pod    │            │           │  │
│  │  │  └──────────┘  └──────────┘            │           │  │
│  │  └────────────────────────────────────────┘           │  │
│  │         │                        │                    │  │
│  │  ┌──────┴────────┐        ┌──────┴────────┐           │  │
│  │  │ Private Subnet│        │ Private Subnet│           │  │
│  │  │   (AZ-1a)     │        │   (AZ-1b)     │           │  │
│  │  │               │        │               │           │  │
│  │  │  ┌─────────┐  │        │  ┌─────────┐  │           │  │
│  │  │  │   RDS   │  │        │  │   RDS   │  │           │  │
│  │  │  │  (Read) │  │        │  │(Primary)│  │           │  │
│  │  │  └─────────┘  │        │  └─────────┘  │           │  │
│  │  │               │        │               │           │  │
│  │  │  ┌─────────┐  │        │  ┌─────────┐  │           │  │
│  │  │  │ElastiC. │  │        │  │ElastiC. │  │           │  │
│  │  │  │ (Redis) │  │        │  │ (Redis) │  │           │  │
│  │  │  └─────────┘  │        │  └─────────┘  │           │  │
│  │  └───────────────┘        └───────────────┘           │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              Monitoring Stack                         │  │
│  │  ┌──────────────┐    ┌──────────────┐                 │  │
│  │  │  Prometheus  │──> │   Grafana    │                 │  │
│  │  │   (Metrics)  │    │ (Dashboards) │                 │  │
│  │  └──────────────┘    └──────────────┘                 │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Microservices Communication

```
User Browser
     │
     ▼
┌─────────────┐
│  Frontend   │ (React, Port 3000)
│   Service   │
└──────┬──────┘
       │ HTTP/WebSocket
       ▼
┌─────────────┐      ┌──────────────┐
│  Backend    │─────>│  WebSocket   │
│   Service   │      │   Service    │
│ (Port 5000) │      │ (Port 5001)  │
└──────┬──────┘      └──────┬───────┘
       │                    │
       │ PostgreSQL         │ Redis
       ▼                    ▼
┌─────────────┐      ┌──────────────┐
│     RDS     │      │ ElastiCache  │
│ PostgreSQL  │      │    Redis     │
└─────────────┘      └──────────────┘
```

### 2.3 Data Flow

1. **User Request** → Frontend Pod
2. **API Call** → Frontend → Backend Service
3. **Database Query** → Backend → RDS PostgreSQL
4. **Real-time Message** → WebSocket → Redis Pub/Sub → All Connected Clients
5. **Session Storage** → Redis Cache
6. **Metrics Collection** → All Services → Prometheus → Grafana

---

## 3. CI/CD Pipeline Implementation

### 3.1 Pipeline Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    GitHub Repository                        │
└────────────────────┬────────────────────────────────────────┘
                     │ git push / PR
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              GitHub Actions Workflow                        │
│                                                             │
│  Stage 1: Build & Test                                      │
│  ├─ Checkout code                                           │
│  ├─ Lint (ESLint, Flake8)                                   │
│  ├─ Unit tests (Jest, Pytest)                               │
│  └─ Code coverage report                                    │
│                                                             │
│  Stage 2: Security Scanning                                 │
│  ├─ Trivy container scan                                    │
│  ├─ Secret detection (GitLeaks)                             │
│  └─ Dependency vulnerability check (Snyk)                   │
│                                                             │
│  Stage 3: Docker Build & Push                               │
│  ├─ Build multistage Docker images                          │
│  ├─ Tag with commit SHA & version                           │
│  └─ Push to Docker Hub / AWS ECR                            │
│                                                             │
│  Stage 4: Infrastructure Provision                          │
│  ├─ Terraform init                                          │
│  ├─ Terraform plan                                          │
│  └─ Terraform apply (on main branch)                        │
│                                                             │
│  Stage 5: Deploy to Kubernetes                              │
│  ├─ Update image tags in manifests                          │
│  ├─ kubectl apply -f k8s/                                   │
│  └─ Run Ansible playbooks                                   │
│                                                             │
│  Stage 6: Post-Deploy Tests                                 │
│  ├─ Health check endpoints                                  │
│  ├─ Smoke tests                                             │
│  └─ Integration tests                                       │
└─────────────────────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              Production Environment (AWS)                   │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Deployment Strategy

**Rolling Update Strategy:**
- Maximum surge: 1 pod
- Maximum unavailable: 0 pods
- Zero-downtime deployments
- Automatic rollback on failure

**Branch Strategy:**
- `main` → Production deployment
- `develop` → Staging deployment
- `feature/*` → Build & test only
- Pull requests require approval + CI pass

### 3.3 Pipeline Execution Time

| Stage                    | Average Duration                           |
|--------------------------|--------------------------------------------|
| Build & Test             | 3-5 minutes                                |
| Security Scanning        | 2-3 minutes                                |
| Docker Build & Push      | 4-6 minutes                                |
| Infrastructure Provision | 8-12 minutes (first run), 1-2 min(updates) |
| Kubernetes Deploy        | 2-4 minutes                                |
| Post-Deploy Tests        | 1-2 minutes                                |
| **Total**                | **~20-30 minutes**                         |

---

## 4. Infrastructure as Code (Terraform)

### 4.1 Infrastructure Components

#### RDS PostgreSQL
- **Instance Class**: db.t3.medium
- **Engine Version**: 15.0
- **Multi-AZ**: Yes (High Availability)
- **Backup Retention**: 7 days
- **Encryption**: Enabled

#### ElastiCache Redis
- **Node Type**: cache.t3.micro
- **Engine Version**: 7.0
- **Replication**: Enabled
- **Automatic Failover**: Enabled

### 4.2 Resource Count

| Resource Type       | Count                   |
|---------------------|-------------------------|
| VPC                 | 1                       |
| Subnets             | 4 (2 public, 2 private) |
| Security Groups     | 5                       |
| EC2 Node Group      | 1 (2 nodes)             |
| RDS Instance        | 1                       |
| ElastiCache Cluster | 1                       |
| Load Balancers      | 1                       |
| IAM Roles           | 3                       |
| **Total Resources** | **~45+**                |

---

## 5. Kubernetes Deployment

### 5.1 Namespace Organization

```yaml
Namespaces:
  - chat-app-dev        # Development environment
  - chat-app-staging    # Staging environment
  - chat-app-prod       # Production environment
  - monitoring          # Prometheus & Grafana
  - ingress-nginx       # Ingress controller
```

### 5.2 Deployment Configuration

**Frontend Deployment:**
```yaml
Replicas: 3
Image: chatapp/frontend:latest
Resources:
  Requests: 100m CPU, 128Mi Memory
  Limits: 200m CPU, 256Mi Memory
Probes:
  Liveness: HTTP GET /health (port 3000)
  Readiness: HTTP GET /health (port 3000)
```

**Backend Deployment:**
```yaml
Replicas: 3
Image: chatapp/backend:latest
Resources:
  Requests: 200m CPU, 256Mi Memory
  Limits: 500m CPU, 512Mi Memory
Environment: From ConfigMap & Secrets
```

**WebSocket Deployment:**
```yaml
Replicas: 2
Image: chatapp/websocket:latest
Resources:
  Requests: 150m CPU, 192Mi Memory
  Limits: 300m CPU, 384Mi Memory
```

### 5.3 Service Types

| Service           | Type         | Ports   |
|-------------------|--------------|---------|
| frontend-service  | LoadBalancer | 80→3000 |
| backend-service   | ClusterIP    | 5000    |
| websocket-service | ClusterIP    | 5001    |
| postgres-service  | ClusterIP    | 5432    |
| redis-service     | ClusterIP    | 6379    |

### 5.4 ConfigMaps & Secrets

**ConfigMap** (`app-config`):
- Application settings
- Feature flags
- Non-sensitive configuration

**Secrets** (`app-secrets`):
- Database credentials
- Redis password
- JWT secret keys
- API keys

### 5.5 Ingress Configuration

```yaml
Host: chat.example.com
TLS: Enabled (Let's Encrypt)
Rules:
  - / → frontend-service:80
  - /api → backend-service:5000
  - /ws → websocket-service:5001
```

---

## 6. Configuration Management (Ansible)

### 6.1 Playbook Tasks

1. **System Preparation**
   - Update packages
   - Install dependencies
   - Configure firewall
   - Set timezone & NTP

2. **Docker Installation**
   - Install Docker CE
   - Configure Docker daemon
   - Add users to docker group
   - Enable Docker service

3. **Kubernetes Node Setup**
   - Install kubectl
   - Install helm
   - Configure kubeconfig
   - Join nodes to cluster

4. **Application Deployment**
   - Copy configuration files
   - Deploy secrets
   - Apply Kubernetes manifests
   - Verify deployments

5. **Monitoring Setup**
   - Install node-exporter
   - Configure Prometheus targets
   - Deploy Grafana agents

### 6.2 Ansible Execution

```bash
# Test connectivity
ansible all -i inventory/hosts.ini -m ping

# Run full playbook
ansible-playbook -i inventory/hosts.ini playbook.yml

# Run specific role
ansible-playbook -i inventory/hosts.ini playbook.yml --tags docker

# Dry run
ansible-playbook -i inventory/hosts.ini playbook.yml --check
```

---

## 7. Monitoring & Observability

### 7.1 Prometheus Configuration

**Scrape Targets:**
- Kubernetes API server
- Node exporter (infrastructure metrics)
- cAdvisor (container metrics)
- Application metrics endpoints
- PostgreSQL exporter
- Redis exporter

**Retention**: 15 days  
**Scrape Interval**: 15 seconds  
**Storage**: 50GB persistent volume

### 7.2 Grafana Dashboards

**Dashboard 1: Kubernetes Cluster Overview**
- Node CPU, Memory, Disk usage
- Pod status and distribution
- Namespace resource consumption
- Network I/O

**Dashboard 2: Application Performance**
- HTTP request rate
- Response time (p50, p95, p99)
- Error rate
- Active WebSocket connections

**Dashboard 3: Database Monitoring**
- PostgreSQL connections
- Query performance
- Table sizes
- Replication lag

**Dashboard 4: Redis Performance**
- Hit/miss ratio
- Memory usage
- Key distribution
- Command statistics

**Dashboard 5: Infrastructure**
- EC2 instance metrics
- Load balancer requests
- Network traffic
- Cost analysis

---

## 8. Security Implementation

### 8.1 Secret Management Strategy

**1. Development Environment:**
- Local `.env` files (gitignored)
- Docker secrets for docker-compose

**3. CI/CD:**
- GitHub Secrets for pipeline
- Environment-specific secrets
- Rotation policy: 90 days


### 8.2 Access Control

**IAM Roles:**
- node role (minimal permissions)
- CI/CD role (deployment only)
- Admin role (full access, MFA required)

**RBAC (Kubernetes):**
```yaml
Roles:
  - Admin: Full cluster access
  - Developer: Namespace access only
  - CI/CD: Deployment permissions
  - Read-only: View-only access
```

### 9.3 Disaster Recovery Plan

**1. Complete AWS Failure:**
   - Restore infrastructure in different region (Terraform)
   - Restore database from backup
   - Deploy application (CI/CD)

**2. Database Corruption:**
   - Promote read replica to primary
   - Restore from point-in-time backup

**3. Application Failure:**
   - Automatic pod restart (Kubernetes)
   - Rollback to previous version
   - Scale up replicas

---

## 11. Lessons Learned

### 11.1 What Went Well ✅

1. **Infrastructure as Code**
   - Terraform made AWS provisioning repeatable and version-controlled
   - Easy to tear down and recreate environments
   - Team members could work on infra simultaneously

2. **Kubernetes Orchestration**
   - Auto-scaling handled traffic spikes effectively
   - Rolling updates achieved zero-downtime deployments
   - Self-healing recovered from pod failures automatically

3. **CI/CD Pipeline**
   - GitHub Actions provided fast, reliable automation
   - Early detection of issues through automated testing
   - Reduced deployment time from hours to minutes

4. **Monitoring**
   - Prometheus + Grafana gave excellent visibility
   - Alerts helped catch issues before users noticed
   - Historical data useful for capacity planning

5. **Team Collaboration**
   - Clear division of responsibilities
   - Git workflow enabled parallel development
   - Regular standups kept everyone aligned

### 11.2 Best Practices Established 📋

1. **Never commit secrets to Git** - Use .gitignore, secrets management
2. **Always use multistage Docker builds** - Reduces image size significantly
3. **Tag everything properly** - Images, resources, commits
4. **Test locally before deploying** - Docker Compose for rapid testing
5. **Monitor everything** - If you can't measure it, you can't improve it
6. **Automate everything** - Manual processes lead to errors
7. **Document as you go** - Future you will thank present you

---

## 16. Conclusion

This project successfully demonstrates the implementation of a complete DevOps stack for a production-ready application. We achieved:

✅ **100% Infrastructure Automation** - Everything is codified and reproducible  
✅ **Zero-Downtime Deployments** - Achieved through Kubernetes rolling updates  
✅ **Comprehensive Monitoring** - Full visibility into application and infrastructure  
✅ **Security Best Practices** - Proper secret management and network isolation  
✅ **Scalability** - Auto-scaling handles load variations  
✅ **High Availability** - Multi-AZ deployment with automated failover  

The project showcases real-world DevOps engineering skills applicable to enterprise environments. The infrastructure is maintainable, scalable, and follows industry best practices.

**Key Takeaway:** DevOps is not just about tools; it's about culture, collaboration, and continuous improvement. This project gave us hands-on experience with the entire software delivery lifecycle.

---
