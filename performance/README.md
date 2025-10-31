# Performance Optimization

Scripts y configuraciones para optimización de rendimiento del pipeline y aplicación.

## Scripts Disponibles

### benchmark.sh
Ejecuta benchmarks completos del pipeline CI/CD.

```bash
bash performance/benchmark.sh
```

**Métricas medidas:**
- Instalación de dependencias (backend/frontend)
- Linting (ESLint)
- Testing (Jest)
- Build (producción)
- Docker builds

**Reportes:** `performance/benchmarks/benchmark-YYYYMMDD-HHMMSS.json`

### load-test.sh
Pruebas de carga para evaluar rendimiento de la aplicación.

```bash
# Uso básico
bash performance/load-test.sh http://localhost:3000

# Custom configuration
bash performance/load-test.sh http://localhost:3000 120 20
# Args: URL, duration (seconds), concurrent users
```

**Requisitos:** Apache Bench (`apache2-utils`)

**Métricas:**
- Requests per second
- Response time (avg, p50, p95, p99)
- Transfer rate
- Failed requests

## Workflow de Performance

El workflow `performance.yml` implementa:

1. **Caching optimizado**
   - Node modules cache
   - Docker layer cache
   - Build artifacts cache

2. **Paralelización**
   - Backend y Frontend builds en paralelo
   - Tests y linting concurrentes
   - Docker builds simultáneos

3. **Performance tracking**
   - Tiempo total del pipeline
   - Duración de cada job
   - Comparación histórica

4. **Benchmarking automático**
   - Ejecuta semanalmente (domingos 2:00 AM)
   - Manual dispatch disponible

## Optimizaciones Implementadas

### CI/CD Pipeline
- ✅ Dependency caching (npm, node_modules)
- ✅ Docker BuildKit y layer caching
- ✅ Parallel job execution
- ✅ Conditional steps (cache hits)
- ✅ Build artifact reuse

### Backend Performance
- ✅ Connection pooling (PostgreSQL)
- ✅ Compression middleware
- ✅ Keep-alive connections
- ✅ Rate limiting
- ✅ Prometheus metrics

### Frontend Performance
- ✅ Production build optimizations
- ✅ Code splitting
- ✅ Asset compression
- ✅ Browser caching headers

### Docker
- ✅ Multi-stage builds
- ✅ Layer optimization
- ✅ Alpine base images
- ✅ .dockerignore

## Performance Thresholds

| Metric | Warning | Critical |
|--------|---------|----------|
| Response Time | >1s | >3s |
| Memory Usage | >200MB | >400MB |
| CPU Usage | >70% | >90% |
| Pipeline Duration | 5-10min | >10min |
| Failed Requests | >1% | >5% |

## Monitoring

Ver `monitoring/` para dashboards de Grafana con:
- Request rate y latency
- Memory y CPU usage
- Database connections
- Error rates

## Scaling Strategy

### Horizontal Scaling
```yaml
# kubernetes/backend-deployment.yaml
replicas: 3  # Ajustar según carga
```

### Vertical Scaling
```yaml
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "500m"
```

### Auto-scaling (HPA)
```bash
kubectl apply -f kubernetes/hpa.yaml
# Min: 3, Max: 10 replicas
# Target: 70% CPU utilization
```

## Best Practices

1. **Cache aggressively**
   - Dependencies en CI/CD
   - Database query results
   - Static assets

2. **Monitor continuously**
   - Pipeline execution times
   - Application performance
   - Resource usage

3. **Test under load**
   - Ejecutar load tests regularmente
   - Simular picos de tráfico
   - Identificar bottlenecks

4. **Optimize incrementally**
   - Benchmark antes y después
   - Documentar cambios
   - Medir impacto real

## Troubleshooting

### Pipeline lento
```bash
# Ver cache hits
cat .github/workflows/performance.yml | grep cache

# Benchmark local
bash performance/benchmark.sh
```

### Alta latencia
```bash
# Load test
bash performance/load-test.sh http://localhost:3000

# Ver métricas
curl http://localhost:3000/metrics
```

### Memory leaks
```bash
# Monitor memoria
docker stats

# Prometheus metrics
process_resident_memory_bytes
```
