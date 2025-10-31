# CRUD DevOps Project

Production-ready DevOps pipeline with free tools for a CRUD application.

## Tech Stack

- **Backend**: Node.js + Express + PostgreSQL
- **Frontend**: React
- **Infrastructure**: Terraform + Render
- **Database**: Railway (PostgreSQL)
- **CI/CD**: GitHub Actions
- **Containerization**: Docker + K3d (Kubernetes)
- **Monitoring**: Grafana Cloud + Prometheus + UptimeRobot
- **Security**: CodeQL + Trivy + OWASP ZAP

## Project Structure

```
crud-devops-project/
├── backend/              # Node.js API
├── frontend/             # React UI
├── infrastructure/       # Terraform IaC
├── k8s/                  # Kubernetes manifests
├── monitoring/           # Prometheus config
├── .github/workflows/    # CI/CD pipelines
└── docker-compose.yml    # Local development
```

## Getting Started

### Prerequisites

- Node.js 18+
- Docker & Docker Compose
- Terraform CLI
- kubectl & k3d

### Local Development

```bash
# Install dependencies
cd backend && npm install
cd ../frontend && npm install

# Start with Docker Compose
docker-compose up
```

## Environment Variables

Create `.env` files in backend and frontend directories:

**Backend `.env`:**
```
DATABASE_URL=postgresql://user:password@localhost:5432/cruddb
PORT=3000
```

**Frontend `.env`:**
```
REACT_APP_API_URL=http://localhost:3000
```

## Deployment

Automatic deployment via GitHub Actions on push to `main` branch.

## Monitoring

- **Grafana Cloud**: Metrics and dashboards
- **UptimeRobot**: External availability monitoring
- **Health Endpoint**: `/healthz`

## License

MIT
