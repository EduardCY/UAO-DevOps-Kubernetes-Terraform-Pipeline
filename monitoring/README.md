# Monitoring Configuration

Sistema completo de monitoreo con Prometheus y Grafana para la aplicación CRUD.

## 📁 Estructura de Archivos

```
monitoring/
├── prometheus.yml              # Configuración de Prometheus
├── alert_rules.yml            # Reglas de alertas
├── docker-compose.yml         # Stack de monitoreo local
├── grafana/
│   ├── grafana.ini           # Configuración de Grafana
│   ├── datasources/
│   │   └── prometheus.yml    # Datasource Prometheus
│   └── dashboards/
│       ├── overview.json     # Dashboard general
│       └── database.json     # Dashboard de base de datos
└── README.md
```

## 🚀 Inicio Rápido

```bash
cd monitoring
docker-compose up -d
```

Servicios:
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3001 (admin/admin)

## 📊 Dashboards

- **Overview**: Request rate, response time, errors, CPU/Memory
- **Database**: Connections, queries, performance

## 🔔 Alertas

Critical: ServiceDown, DatabaseConnectionFailed
Warning: HighErrorRate, SlowResponseTime, HighMemoryUsage

## 🌐 Grafana Cloud

Configurar remote_write en `prometheus.yml` con credenciales de Grafana Cloud.
