# DevOps Intern Take-Home Assessment

## 1. Application Overview

The application is a simple document and item management system consisting of:
- A React + TypeScript frontend
- A FastAPI backend
- A PostgreSQL database
- S3-compatible object storage for uploaded files

The application allows users to:
- View application health
- Create, view, update, and delete items
- Upload files
- View uploaded files
- Download/open uploaded files
- Delete uploaded files

---
#.2 Prerequisites
- Git
- Docker Engine / Docker Desktop
- Docker Compose
- Node.js 22+ and npm
- Python 3.13+
- PostgreSQL — required for direct local backend development
- MinIO — required for direct local backend development

Verify:
git --version
docker --version
docker compose version

---
# 3. Repository Structure

 ```text
 .
 ├── backend/
 │    ├── Dockerfile
 │    └── .env
 ├── frontend/
 │    ├── Dockerfile
 │    ├── .env
 │    └── nginx
 │          └── default.conf 
 ├── deployment/
 │    ├── README.md
 │    ├── current_version
 │     └── known_good_version
 ├── scripts/
 │    ├── local.sh
 │    ├── deploy.sh
 │    └── rollback.sh 
 ├── .env
 ├── .env.prod
 ├── .env.example
 ├── docker-compose.yml
 └── docker-compose.prod.yml
```
---
# 4. Clone the repo
```bash
git clone https://github.com/anusree-ux/devops-assessment
cd devops-assessment
```
# 5. Configure env variables
Copy the example environment files:
```
cp .env.example .env
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env
```
---
# 6. Start the application
```
chmod +x ./scripts/local.sh
./scripts/local.sh start
```
To check status 
```
./scripts/local.sh status
```
To check logs
```
./scripts/local.sh logs
```
To Stop the application
```
./scripts/local.sh stop
```
---
# 7. Access the application
Frontend : http://app.debyez.localhost

Backend API  : http://api.debyez.localhost/api/health

---
# 8. Production deployment
Clone the repository:
Create the production environment file:
```
cp .env.example .env.prod
```
---
# 9. Deploy the production version

Make the deployment scripts executable:
```
chmod +x ./scripts/deploy.sh
chmod +x ./scripts/rollback.sh
```
Deploy:
```
./scripts/deploy.sh
```
Alternatively, production can be started manually with:
```
docker compose --env-file .env.prod -f docker-compose.prod.yml pull
docker compose --env-file .env.prod -f docker-compose.prod.yml up -d
```
Check the production containers:
```
docker compose --env-file .env.prod -f docker-compose.prod.yml ps
```
