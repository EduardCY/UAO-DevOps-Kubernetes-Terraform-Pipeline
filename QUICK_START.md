# 🚀 Quick Start Guide - Local Development

This guide will help you run the CRUD application locally for development.

## Prerequisites

Make sure you have installed:
- Node.js >= 18.0.0
- npm >= 9.0.0
- Docker & Docker Compose (for containerized setup)
- PostgreSQL (for manual setup)

## Option 1: Docker Compose (Recommended) 🐳

The easiest way to run the entire stack:

### 1. Start all services
```bash
docker-compose up -d
```

This will start:
- PostgreSQL database on port 5432
- Backend API on port 3000
- Frontend React app on port 3001

### 2. View logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f postgres
```

### 3. Stop services
```bash
docker-compose down

# Stop and remove volumes (clean slate)
docker-compose down -v
```

### 4. Access the application
- **Frontend**: http://localhost:3001
- **Backend API**: http://localhost:3000
- **Health Check**: http://localhost:3000/healthz
- **Metrics**: http://localhost:3000/metrics

---

## Option 2: Manual Setup (Development) 💻

If you prefer to run services individually:

### 1. Setup PostgreSQL Database

#### Using Docker:
```bash
docker run -d \
  --name postgres-dev \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=admin123 \
  -e POSTGRES_DB=crud_db \
  -p 5432:5432 \
  postgres:14-alpine
```

#### Initialize database:
```bash
# Connect to PostgreSQL
psql postgresql://admin:admin123@localhost:5432/crud_db

# Or using docker exec
docker exec -i postgres-dev psql -U admin -d crud_db < infrastructure/db.sql
```

### 2. Setup Backend

```bash
cd backend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Edit .env with your database connection
# DATABASE_URL=postgresql://admin:admin123@localhost:5432/crud_db

# Run in development mode
npm run dev

# Or run tests
npm test

# Lint code
npm run lint
```

Backend will run on http://localhost:3000

### 3. Setup Frontend

```bash
cd frontend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Edit .env with backend URL
# REACT_APP_API_URL=http://localhost:3000

# Start development server
npm start

# Or run tests
npm test

# Build for production
npm run build
```

Frontend will run on http://localhost:3001

---

## 🧪 Testing

### Backend Tests
```bash
cd backend

# Run all tests
npm test

# Run tests with coverage
npm test -- --coverage

# Run tests in watch mode
npm run test:watch
```

### Frontend Tests
```bash
cd frontend

# Run all tests
npm test

# Run tests with coverage
npm test -- --coverage
```

---

## 🔍 Verify Everything Works

### 1. Check Backend Health
```bash
curl http://localhost:3000/healthz
# Expected: {"status":"ok","timestamp":"..."}

curl http://localhost:3000/readiness
# Expected: {"status":"ready","database":"connected",...}
```

### 2. Test API Endpoints
```bash
# Get all users
curl http://localhost:3000/users

# Create a user
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User"}'

# Get user by ID
curl http://localhost:3000/users/1

# Update user
curl -X PUT http://localhost:3000/users/1 \
  -H "Content-Type: application/json" \
  -d '{"name":"Updated Name"}'

# Delete user
curl -X DELETE http://localhost:3000/users/1
```

### 3. Check Prometheus Metrics
```bash
curl http://localhost:3000/metrics
```

---

## 🐛 Troubleshooting

### Backend won't start
- **Check if PostgreSQL is running**: `docker ps` or check local PostgreSQL service
- **Verify DATABASE_URL**: Make sure connection string is correct in `.env`
- **Check port 3000**: Ensure nothing else is using port 3000
- **View logs**: `docker-compose logs backend` or check terminal output

### Frontend won't start
- **Check backend is running**: Visit http://localhost:3000/healthz
- **Verify REACT_APP_API_URL**: Check `.env` file
- **Check port 3001**: Ensure nothing else is using port 3001
- **Clear cache**: Delete `node_modules` and run `npm install` again

### Database connection errors
- **Check PostgreSQL is running**: `docker ps | grep postgres`
- **Test connection**: 
  ```bash
  psql postgresql://admin:admin123@localhost:5432/crud_db
  ```
- **Recreate database**:
  ```bash
  docker-compose down -v
  docker-compose up -d postgres
  ```

### Docker Compose issues
- **Ports already in use**: Check if another process is using ports 3000, 3001, or 5432
  ```bash
  # Windows
  netstat -ano | findstr :3000
  netstat -ano | findstr :3001
  netstat -ano | findstr :5432
  
  # Linux/Mac
  lsof -i :3000
  lsof -i :3001
  lsof -i :5432
  ```
- **Build cache issues**: 
  ```bash
  docker-compose build --no-cache
  docker-compose up -d
  ```

---

## 📁 Project Structure

```
.
├── backend/              # Node.js API
│   ├── src/
│   │   ├── index.js     # Main application
│   │   └── index.test.js
│   ├── Dockerfile
│   ├── package.json
│   └── .env.example
├── frontend/            # React app
│   ├── src/
│   │   ├── App.js       # Main component
│   │   ├── App.css
│   │   └── App.test.js
│   ├── public/
│   ├── Dockerfile
│   ├── nginx.conf
│   ├── package.json
│   └── .env.example
├── infrastructure/
│   └── db.sql           # Database schema
└── docker-compose.yml   # Docker setup
```

---

## 🎯 Next Steps

Once your local environment is running:

1. ✅ Make code changes and see live reload
2. ✅ Write tests for new features
3. ✅ Run linting before committing: `npm run lint`
4. ✅ Commit following [Conventional Commits](https://www.conventionalcommits.org/)
5. ✅ Push to GitHub to trigger CI/CD pipeline

---

## 💡 Tips

- Use `npm run dev` for backend hot-reload
- React dev server has hot-reload by default
- Check Docker logs frequently: `docker-compose logs -f`
- Use Postman or curl to test API endpoints
- Keep `.env` files secure (never commit them!)

---

## 📚 Additional Resources

- [Backend README](./backend/README.md)
- [Frontend README](./frontend/README.md)
- [Main README](./README.md)
- [Setup Manual](./SETUP_MANUAL.md)

---

**Happy Coding! 🎉**
