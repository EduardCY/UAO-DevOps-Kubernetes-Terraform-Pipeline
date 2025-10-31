# Kubernetes Manifests

Manifiestos K8s para despliegue en cluster local (K3d) o producción.

## Recursos
- `deployment.yaml` - Deployment con 3 replicas
- `service.yaml` - ClusterIP service
- `ingress.yaml` - Ingress para acceso externo
- `configmap.yaml` - Configuration
- `secret.yaml` - Secrets (NO commitear valores reales)

## Deploy
```bash
kubectl apply -f k8s/
kubectl get pods
kubectl get services
```
