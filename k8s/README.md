# Kubernetes Manifests

Esta carpeta contiene todos los manifiestos de Kubernetes necesarios para desplegar la aplicación CRUD en un cluster de Kubernetes.

## 📁 Estructura de Archivos

```
k8s/
├── namespace.yaml              # Namespace aislado para la app
├── configmap.yaml              # Configuración no sensible
├── secret.yaml.example         # Template para secrets (base64)
├── backend-deployment.yaml     # Deployment del backend (3 réplicas)
├── backend-service.yaml        # Service ClusterIP para backend
├── frontend-deployment.yaml    # Deployment del frontend (3 réplicas)
├── frontend-service.yaml       # Service ClusterIP para frontend
├── ingress.yaml                # Ingress para routing HTTP/HTTPS
├── hpa.yaml                    # Horizontal Pod Autoscaler
├── kustomization.yaml          # Kustomize config
└── README.md                   # Esta guía
```

## 🚀 Despliegue Rápido

### Pre-requisitos

1. **Cluster de Kubernetes** funcionando (puede ser k3d, minikube, o cloud)
2. **kubectl** instalado y configurado
3. **Ingress Controller** (nginx) instalado en el cluster

### Aplicar con Kustomize

```bash
# Ver manifiestos generados
kubectl kustomize k8s/

# Aplicar todo de una vez
kubectl apply -k k8s/

# Ver recursos en el namespace
kubectl get all -n crud-app
```

## 📊 Características Implementadas

### High Availability
- **3 réplicas** de cada servicio para tolerancia a fallos
- **Rolling updates** con MaxSurge=1 y MaxUnavailable=1

### Health Checks
- **Liveness probes**: Reinicia pods no saludables
- **Readiness probes**: Evita tráfico a pods no listos
- **Startup probes**: Maneja contenedores de inicio lento

### Resource Management
- **Requests y Limits**: Control de recursos CPU/memoria
- **HPA**: Escala automáticamente bajo carga (3-10 pods)

### Security
- **Non-root containers**: Mayor seguridad
- **Secrets management**: Credenciales en Secrets
- **Namespace isolation**: Aislamiento de recursos

## 🧪 Testing Local con k3d

```bash
# Crear cluster k3d con ingress
k3d cluster create crud-cluster \
  --port "8080:80@loadbalancer" \
  --port "8443:443@loadbalancer"

# Aplicar manifiestos
kubectl apply -k k8s/

# Verificar pods
kubectl get pods -n crud-app
```
