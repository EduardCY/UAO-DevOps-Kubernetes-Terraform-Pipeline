# Security Configuration

Scripts y configuraciones para análisis de seguridad automático.

## Scripts Disponibles

### check-secrets.sh
Detecta secretos y credenciales hardcodeadas en el código fuente.

```bash
bash security/check-secrets.sh
```

**Patrones detectados:**
- API_KEY, SECRET_KEY, PASSWORD
- PRIVATE_KEY, AWS_SECRET
- DATABASE_URL, JWT_SECRET
- access_token, client_secret

### check-dependencies.sh
Analiza vulnerabilidades en dependencias npm y Docker base images.

```bash
bash security/check-dependencies.sh
```

**Checks:**
- `npm audit` con nivel moderate
- Análisis de imágenes base de Docker
- Reporte JSON de vulnerabilidades

## Integración CI/CD

Estos scripts se ejecutan automáticamente en:
- `.github/workflows/security.yml` - Cada push/PR
- Pre-commit hooks (opcional)

## Thresholds de Seguridad

| Severidad | Acción | Tool |
|-----------|--------|------|
| Critical  | ❌ Fail build | Trivy, CodeQL |
| High      | ❌ Fail build | Trivy, npm audit |
| Medium    | ⚠️ Warning | OWASP ZAP |
| Low       | ℹ️ Info | OWASP ZAP |

## Reportes

Los reportes de seguridad se generan en:
- `security/npm-audit-report.json`
- GitHub Security tab (CodeQL, Dependabot)
- Workflow run artifacts

## Remediación Rápida

```bash
# Fix vulnerabilities automáticamente
cd backend
npm audit fix

# Ver detalles
npm audit

# Forzar actualización (con breaking changes)
npm audit fix --force
```

## Best Practices

1. ✅ Usar variables de entorno para secretos
2. ✅ Mantener dependencias actualizadas
3. ✅ Revisar security alerts de GitHub
4. ✅ Ejecutar checks localmente antes de push
5. ✅ Nunca commitear archivos `.env`
