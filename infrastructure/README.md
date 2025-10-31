# Infrastructure as Code

Configuración Terraform para provisionar infraestructura en Render.

## Recursos
- Web Service (Render)
- Environment variables
- Auto-deploy configuration

## Uso
```bash
terraform init
terraform plan
terraform apply
```

## Variables Requeridas
- `render_api_key` - API key de Render
- `database_url` - Connection string de PostgreSQL
