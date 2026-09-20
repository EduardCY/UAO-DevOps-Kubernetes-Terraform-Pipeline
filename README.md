# ☸️ UAO - Infraestructura Cloud, Kubernetes y Pipeline DevOps con Seguridad OWASP

[![UAO](https://img.shields.io/badge/Universidad-Aut%C3%B3noma_de_Occidente-red?style=for-the-badge&logo=academia)](https://www.uao.edu.co/)
[![Materia](https://img.shields.io/badge/Asignatura-Ingenier%C3%ADa_de_Software_2-blue?style=for-the-badge)](https://github.com/EduardCY/UAO-DevOps-Kubernetes-Terraform-Pipeline)
[![Kubernetes](https://img.shields.io/badge/Orquestación-Kubernetes_k8s-326CE5?style=for-the-badge&logo=kubernetes)](https://kubernetes.io/)
[![Terraform](https://img.shields.io/badge/IaC-Terraform-7B42BC?style=for-the-badge&logo=terraform)](https://www.terraform.io/)
[![Prometheus & Grafana](https://img.shields.io/badge/Monitoreo-Prometheus_%2B_Grafana-E6522C?style=for-the-badge&logo=grafana)](https://grafana.com/)
[![Security: OWASP ZAP](https://img.shields.io/badge/Seguridad-OWASP_ZAP_Scan-blueviolet?style=for-the-badge&logo=owasp)](https://owasp.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Author](https://img.shields.io/badge/Author-Eduard_Criollo_Yule-purple?style=for-the-badge&logo=github)](https://github.com/EduardCY)

> **Plataforma Integral de Infraestructura como Código (IaC), Orquestación de Contenedores y DevSecOps** que incluye despliegues automatizados en Kubernetes (k8s), aprovisionamiento con Terraform, observabilidad completa (Prometheus + Grafana) y escaneo dinámico de vulnerabilidades (DAST con OWASP ZAP).

---

## 🏛️ Arquitectura de DevSecOps & Infraestructura

```mermaid
flowchart TD
    subgraph IaC["Infraestructura como Código (Terraform)"]
        TF[Terraform Plan & Apply] --> VPC[VPC & Networking]
        TF --> Cluster[Cluster Kubernetes / Minikube]
    end

    subgraph K8s["Clúster Kubernetes"]
        Ingress[Ingress Controller NGINX] --> SvcApp[Service: Application]
        SvcApp --> Pod1[Pod: Backend v1]
        SvcApp --> Pod2[Pod: Backend v2]
        Config[ConfigMaps & Secrets] -. Inyecta .-> Pod1
    end

    subgraph Observability["Observabilidad & Monitoreo"]
        Prometheus[Prometheus Server] -->|Scrape /metrics| Pod1
        Prometheus --> Grafana[Grafana Dashboards]
    end

    subgraph DevSecOps["Seguridad Dinámica"]
        ZAP[OWASP ZAP DAST Scan] -->|Analiza Superficie Web| Ingress
        Alerts[Alertmanager]
    end
```

---

## 🔒 Capas de DevSecOps Implementadas

1. **Escaneo Estático y Dinámico (SAST/DAST):** Integración de análisis con OWASP ZAP contra endpoints públicos.
2. **Infraestructura Declarativa:** Módulos de Terraform para replicabilidad ambiental idéntica (*Dev, Staging, Prod*).
3. **Observabilidad en Tiempo Real:** Métricas de latencia p95/p99, tasa de error HTTP y consumo de CPU/Memoria en Grafana.

---

## 🚀 Guía de Inicio Rápido

Consulta [`QUICK_START.md`](QUICK_START.md) y [`SETUP_MANUAL.md`](SETUP_MANUAL.md) para detalles completos de configuración paso a paso.

```bash
git clone https://github.com/EduardCY/UAO-DevOps-Kubernetes-Terraform-Pipeline.git
cd UAO-DevOps-Kubernetes-Terraform-Pipeline

# Levantar entorno local con Docker Compose
docker compose up -d
```

---

## 👨‍💻 Autor

* **Autor:** Eduard Criollo Yule ([@EduardCY](https://github.com/EduardCY))
* **Licencia:** [MIT](LICENSE).
