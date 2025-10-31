# 🚀 CRUD DevOps Project - Production-Ready Pipeline

[![CI/CD Pipeline](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=githubactions)](https://github.com)
[![Docker](https://img.shields.io/badge/Docker-Enabled-2496ED?logo=docker)](https://www.docker.com/)
[![Kubernetes](https://img.shields.io/badge/K8s-K3d-326CE5?logo=kubernetes)](https://k3d.io/)
[![Terraform](https://img.shields.io/badge/IaC-Terraform-7B42BC?logo=terraform)](https://www.terraform.io/)

Pipeline DevOps completo construido con herramientas 100% gratuitas para una aplicación CRUD de gestión de usuarios.

## 📋 Tabla de Contenido

- [Características](#-características)
- [Arquitectura](#-arquitectura)
- [Stack Tecnológico](#-stack-tecnológico)
- [Requisitos Previos](#-requisitos-previos)
- [Configuración](#-configuración)
- [Desarrollo Local](#-desarrollo-local)
- [Deployment](#-deployment)
- [Monitoreo](#-monitoreo)
- [Seguridad](#-seguridad)

## ✨ Características

- **Backend API RESTful** con Node.js + Express
- **Frontend React** moderno y responsive
- **Base de datos PostgreSQL** gratuita (Railway)
- **Containerización** con Docker multi-stage builds
- **Orquestación Kubernetes** (K3d para local)
- **CI/CD automatizado** con GitHub Actions
- **Infrastructure as Code** con Terraform
- **Monitoreo** con Grafana Cloud + Prometheus
- **Seguridad** integrada (CodeQL, Trivy, OWASP ZAP)
- **Deploy gratuito** en Render

## 🏗 Arquitectura

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   Frontend  │─────▶│   Backend   │─────▶│  PostgreSQL │
│   (React)   │      │  (Node.js)  │      │  (Railway)  │
└─────────────┘      └─────────────┘      └─────────────┘
       │                     │                     │
       └─────────────────────┴─────────────────────┘
                             │
                    ┌────────▼────────┐
                    │   Kubernetes    │
                    │    (K3d/K8s)    │
                    └─────────────────┘
                             │
                    ┌────────▼────────┐
                    │   Monitoring    │
                    │ Grafana+Prom    │
                    └─────────────────┘
```

## 🛠 Stack Tecnológico

### Aplicación
- **Backend**: Node.js 18, Express, pg (PostgreSQL client)
- **Frontend**: React 17, Axios
- **Database**: PostgreSQL 14+

### DevOps
- **CI/CD**: GitHub Actions
- **Containerización**: Docker + Docker Compose
- **Orquestación**: Kubernetes (K3d local, Render producción)
- **IaC**: Terraform
- **Monitoreo**: Grafana Cloud, Prometheus, UptimeRobot
- **Seguridad**: CodeQL, Trivy, OWASP ZAP

### Cloud Providers (Free Tier)
- **Render**: Hosting de aplicación
- **Railway**: PostgreSQL database
- **Terraform Cloud**: Remote state
- **Grafana Cloud**: Monitoreo

## 📦 Requisitos Previos

### Software Local
```bash
node >= 18.0.0
npm >= 9.0.0
docker >= 24.0.0
kubectl >= 1.27.0
terraform >= 1.5.0
k3d >= 5.5.0
git >= 2.40.0
```

### Cuentas Necesarias (Gratuitas)
- [ ] GitHub (para código y CI/CD)
- [ ] Render (hosting)
- [ ] Railway (PostgreSQL)
- [ ] Terraform Cloud (state management)
- [ ] Grafana Cloud (monitoreo)
- [ ] UptimeRobot (uptime monitoring)

## ⚙️ Configuración

### 1. Clonar Repositorio
```bash
git clone https://github.com/LeonarDPeace/Final_DevOps_Proyecto.git
cd Final_DevOps_Proyecto
```

### 2. Configurar Secrets en GitHub
Ve a `Settings → Secrets and variables → Actions` y agrega:

```
RENDER_API_KEY          # API key de Render
DATABASE_URL            # Connection string de Railway
TF_API_TOKEN           # Token de Terraform Cloud
GRAFANA_URL            # URL de tu stack de Grafana
GRAFANA_API_KEY        # API Key de Grafana
```

### 3. Configurar Variables de Entorno Locales
```bash
# Backend
cp backend/.env.example backend/.env
# Editar backend/.env con tus credenciales

# Frontend
cp frontend/.env.example frontend/.env
# Editar frontend/.env con la URL del backend
```

## 💻 Desarrollo Local

### Opción 1: Docker Compose (Recomendado)
```bash
# Levantar todos los servicios
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener servicios
docker-compose down
```

**URLs:**
- Frontend: http://localhost:3001
- Backend: http://localhost:3000
- PostgreSQL: localhost:5432

### Opción 2: Manual

#### Backend
```bash
cd backend
npm install
npm run dev
```

#### Frontend
```bash
cd frontend
npm install
npm start
```

#### Database (usar Docker)
```bash
docker run -d \
  --name postgres-dev \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=admin123 \
  -e POSTGRES_DB=crud_db \
  -p 5432:5432 \
  postgres:14-alpine
```

### Tests
```bash
# Backend tests
cd backend && npm test

# Frontend tests
cd frontend && npm test

# Tests con coverage
npm test -- --coverage
```

### Linting
```bash
# Lint backend
cd backend && npm run lint

# Lint frontend
cd frontend && npm run lint

# Fix automático
npm run lint:fix
```

## 🚀 Deployment

### Deploy Automático (CI/CD)
Simplemente haz push a la rama `main`:
```bash
git add .
git commit -m "feat: new feature"
git push origin main
```

GitHub Actions se encargará de:
1. ✅ Ejecutar tests
2. ✅ Linting
3. ✅ Escaneo de seguridad
4. ✅ Build de imágenes Docker
5. ✅ Deploy a Render
6. ✅ Health checks

### Deploy Manual con Terraform
```bash
cd infrastructure

# Inicializar Terraform
terraform init

# Ver plan
terraform plan

# Aplicar cambios
terraform apply -auto-approve
```

### Deploy en Kubernetes Local (K3d)
```bash
# Crear cluster K3d
k3d cluster create dev-cluster \
  --servers 1 \
  --agents 2 \
  --port 8080:80@loadbalancer

# Aplicar manifiestos
kubectl apply -f k8s/

# Ver estado
kubectl get pods
kubectl get services

# Acceder a la app
http://localhost:8080
```

## 📊 Monitoreo

### Grafana Cloud
1. Accede a tu stack: https://grafana.com
2. Dashboards disponibles:
   - **Application Metrics**: Request rate, latency, errors
   - **Infrastructure**: CPU, memory, disk
   - **Database**: Conexiones, queries, performance

### Prometheus Metrics
```bash
# Endpoint de métricas del backend
curl http://localhost:3000/metrics
```

### UptimeRobot
- Monitorea disponibilidad cada 5 minutos
- Alertas por email automáticas
- Dashboard público: [Configurar después del deploy]

### Health Checks
```bash
# Backend health
curl http://localhost:3000/healthz
# Response: {"status":"ok"}

# Backend readiness
curl http://localhost:3000/readiness
# Response: {"status":"ready","database":"connected"}
```

## 🔒 Seguridad

### Escaneos Automáticos
- **CodeQL**: Análisis estático de código (cada PR)
- **Trivy**: Vulnerabilidades en imágenes Docker (cada build)
- **OWASP ZAP**: Escaneo de seguridad web (post-deploy)

### Ver Resultados
```bash
# En GitHub
Security → Code scanning alerts
Security → Dependabot alerts
```

### Mantenimiento de Dependencias
```bash
# Actualizar dependencias
npm audit
npm audit fix

# Verificar vulnerabilidades manualmente
npx npm-check-updates -u
```

## 📁 Estructura del Proyecto

```
.
├── backend/              # API Node.js
│   ├── src/
│   ├── tests/
│   ├── Dockerfile
│   └── package.json
├── frontend/             # React app
│   ├── src/
│   ├── public/
│   ├── Dockerfile
│   └── package.json
├── infrastructure/       # Terraform IaC
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── k8s/                 # Kubernetes manifests
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── monitoring/          # Monitoring configs
│   └── prometheus.yml
├── .github/
│   └── workflows/       # CI/CD pipelines
│       ├── ci.yml
│       ├── security.yml
│       └── deploy.yml
└── docker-compose.yml   # Local development
```

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama: `git checkout -b feature/nueva-feature`
3. Commit: `git commit -m 'feat: agregar nueva feature'`
4. Push: `git push origin feature/nueva-feature`
5. Abre un Pull Request

## 📝 Convenciones de Commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: nueva característica
fix: corrección de bug
docs: cambios en documentación
style: formato, punto y coma faltante, etc
refactor: refactorización de código
test: agregar tests
chore: actualizar dependencias, config, etc
```

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## 👥 Autores

- **Leonardo Peace** - [@LeonarDPeace](https://github.com/LeonarDPeace)

## 🙏 Agradecimientos

- Basado en la guía de [freeCodeCamp](https://www.freecodecamp.org/news/how-to-build-a-production-ready-devops-pipeline-with-free-tools/)
- Comunidad DevOps
- Herramientas open-source

---

⭐ Si este proyecto te fue útil, considera darle una estrella en GitHub
