# GitHub Actions Workflows

Esta carpeta contiene los workflows de CI/CD automatizados para el proyecto.

## 📋 Workflows Disponibles

### 1. CI Pipeline (`ci.yml`)
**Trigger:** Push y Pull Request a `main`

**Jobs:**
- **Backend CI**: Instala dependencias, ejecuta linter, tests y build
- **Frontend CI**: Instala dependencias, ejecuta linter, tests y build
- **Docker Build**: Verifica que las imágenes Docker se construyan correctamente

**Características:**
- Caching de dependencias npm para builds rápidos
- Paralelización de tests backend/frontend
- Verificación de tamaño de bundle
- Matrix builds para múltiples servicios

### 2. Security Scanning (`security.yml`)
**Trigger:** Push a `main`, Pull Request, Schedule (lunes 8 AM)

**Jobs:**
- **CodeQL Analysis**: Análisis estático de código JavaScript
- **Trivy Scan**: Escaneo de vulnerabilidades en imágenes Docker
- **Dependency Scan**: `npm audit` para dependencias vulnerables
- **OWASP ZAP**: Escaneo dinámico de seguridad web (DAST)

**Outputs:**
- Reportes SARIF en GitHub Security tab
- Artifacts con resultados de auditorías

### 3. Deploy to Production (`deploy.yml`)
**Trigger:** Push a `main`, Manual

**Jobs:**
- **Build & Push**: Construye y sube imágenes a GitHub Container Registry
- **Terraform Deploy**: Aplica infraestructura en Render usando Terraform
- **Health Check**: Verifica que los servicios estén funcionando
- **Rollback**: Revierte cambios si los health checks fallan

**Variables requeridas:**
- `TF_API_TOKEN`: Token de Terraform Cloud
- `RENDER_API_KEY`: API Key de Render
- `DATABASE_URL`: Connection string de PostgreSQL

### 4. Docker Build Optimization (`docker-build.yml`)
**Trigger:** Push a `main` con cambios en backend/frontend

**Jobs:**
- **Build Backend**: Construye backend con BuildKit y layer caching
- **Build Frontend**: Construye frontend con optimizaciones
- **Test Compose**: Prueba el stack completo con docker-compose

**Optimizaciones:**
- BuildKit habilitado
- GitHub Actions cache para layers
- Multi-stage builds
- Análisis de tamaño de imágenes

### 5. Monitoring & Alerts (`monitoring.yml`)
**Trigger:** Schedule (cada 30 minutos), Manual

**Jobs:**
- **Metrics Check**: Verifica endpoint `/metrics` de Prometheus
- **Health Monitoring**: Chequea `/healthz` y `/readiness`
- **Database Check**: Verifica conectividad a PostgreSQL
- **Performance Check**: Mide tiempos de respuesta

## 🚀 Configuración Inicial

### Secrets Requeridos

Ir a `Settings → Secrets and variables → Actions` y agregar:

```
DATABASE_URL          # PostgreSQL connection string
RENDER_API_KEY        # API key de Render
TF_API_TOKEN          # Token de Terraform Cloud
GRAFANA_URL           # URL del stack de Grafana (opcional)
GRAFANA_API_KEY       # API key de Grafana (opcional)
```

### Permisos de GitHub Actions

En `Settings → Actions → General`:
- ✅ Allow all actions and reusable workflows
- ✅ Read and write permissions
- ✅ Allow GitHub Actions to create and approve pull requests

### Permisos de GITHUB_TOKEN

Los workflows ya incluyen los permisos necesarios:
```yaml
permissions:
  contents: read
  packages: write
  security-events: write
```

## 📊 Uso de los Workflows

### Ejecución Automática

Los workflows se ejecutan automáticamente:
- **CI**: En cada push y pull request
- **Security**: En push, PR, y semanalmente
- **Deploy**: Solo en push a main
- **Monitoring**: Cada 30 minutos

### Ejecución Manual

Algunos workflows soportan `workflow_dispatch`:

```bash
# Desde GitHub UI:
Actions → [Workflow Name] → Run workflow

# Usando GitHub CLI:
gh workflow run deploy.yml
gh workflow run monitoring.yml
```

## 🔍 Monitoreo de Workflows

### Ver Estado de Workflows

```bash
# Listar runs recientes
gh run list

# Ver detalles de un run
gh run view <run-id>

# Ver logs
gh run view <run-id> --log
```

### Badges de Estado

Agregar al README.md:

```markdown
![CI](https://github.com/LeonarDPeace/Final_DevOps_Proyecto/workflows/CI%20Pipeline/badge.svg)
![Security](https://github.com/LeonarDPeace/Final_DevOps_Proyecto/workflows/Security%20Scanning/badge.svg)
![Deploy](https://github.com/LeonarDPeace/Final_DevOps_Proyecto/workflows/Deploy%20to%20Production/badge.svg)
```

## 🛠️ Troubleshooting

### CI falla en tests
- Verificar que tests pasen localmente: `npm test`
- Revisar logs en GitHub Actions
- Comprobar variables de entorno

### Security scan encuentra vulnerabilidades
- Revisar GitHub Security tab
- Actualizar dependencias: `npm audit fix`
- Revisar resultados de Trivy en artifacts

### Deploy falla
- Verificar secrets configurados correctamente
- Comprobar estado de Terraform Cloud
- Revisar logs de Render

### Health checks fallan
- Verificar que servicios estén desplegados en Render
- Comprobar URLs en workflow
- Revisar logs del backend

## 📈 Métricas y Reportes

### Job Summaries

Cada workflow genera un summary visible en la página del run:
- Estado de todos los jobs
- Links a servicios desplegados
- Métricas de build time
- Resultados de security scans

### Artifacts

Algunos workflows generan artifacts descargables:
- Resultados de `npm audit` (JSON)
- Reportes de OWASP ZAP (HTML/JSON)
- Coverage reports

Descargar desde: `Actions → [Run] → Artifacts`

## 🔐 Seguridad

### Protección de Secrets

- Nunca hacer hardcode de secrets en workflows
- Usar `${{ secrets.SECRET_NAME }}`
- Marcar outputs sensibles como secretos

### Branch Protection

Configurar rules en `Settings → Branches`:
- Require status checks to pass (CI, Security)
- Require pull request reviews
- Require branches to be up to date

## 🎯 Mejores Prácticas

1. **Caching**: Usar cache de npm para builds rápidos
2. **Paralelización**: Jobs independientes corren en paralelo
3. **Fail Fast**: `fail-fast: false` en matrix builds
4. **Conditions**: Usar `if:` para control de ejecución
5. **Timeouts**: Agregar `timeout-minutes` para prevenir hangs
6. **Reusable Workflows**: Considerar extraer lógica común

## 📚 Referencias

- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Workflow Syntax](https://docs.github.com/actions/reference/workflow-syntax-for-github-actions)
- [Security Hardening](https://docs.github.com/actions/security-guides/security-hardening-for-github-actions)
