# Terraform Infrastructure Configuration

Esta carpeta contiene la configuración de Infrastructure as Code (IaC) para desplegar la aplicación CRUD en Render utilizando Terraform.

## 📁 Estructura de Archivos

```
terraform/
├── main.tf                    # Configuración principal de recursos
├── variables.tf               # Definición de variables de entrada
├── outputs.tf                 # Valores de salida después del deployment
├── terraform.tfvars.example   # Plantilla de variables (copiar y renombrar)
├── .terraform.lock.hcl        # Lock file de providers
└── .gitignore                 # Ignorar archivos sensibles
```

## 🚀 Requisitos Previos

1. **Terraform instalado** (>= 1.0)
   ```bash
   terraform --version
   ```

2. **Cuenta en Terraform Cloud**
   - Organización: `devops-crud-org`
   - Workspace: `crud-devops-prod`

3. **Render API Key** (obtener de https://dashboard.render.com/account/api-keys)

4. **DATABASE_URL de Railway** (connection string de PostgreSQL)

## ⚙️ Configuración Inicial

### 1. Configurar Terraform Cloud

Si aún no has configurado Terraform Cloud, ejecuta:

```bash
terraform login
```

### 2. Configurar Variables en Terraform Cloud

Ve a tu workspace `crud-devops-prod` en Terraform Cloud y agrega:

**Terraform Variables:**
- `render_api_key` (Sensitive): Tu API key de Render
- `database_url` (Sensitive): Connection string de Railway PostgreSQL
- `repo_url`: URL de tu repositorio GitHub

**O usando archivo local** (solo para testing):

```bash
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars con tus valores reales
```

### 3. Inicializar Terraform

```bash
cd infrastructure/terraform
terraform init
```

Esto:
- Descarga el provider de Render
- Configura el backend remoto en Terraform Cloud
- Prepara el workspace para deployment

## 📦 Comandos de Deployment

### Validar Configuración

```bash
terraform validate
```

### Ver Plan de Ejecución

```bash
terraform plan
```

Esto muestra qué recursos se crearán/modificarán sin aplicar cambios.

### Aplicar Infraestructura

```bash
terraform apply
```

Revisa el plan y escribe `yes` para confirmar.

### Ver Outputs

```bash
terraform output
```

Muestra las URLs de backend y frontend desplegados.

### Destruir Infraestructura

⚠️ **Solo usar en ambientes de testing:**

```bash
terraform destroy
```

## 🔧 Recursos Creados

### Backend Service (`render_web_service.backend`)
- **Plan**: Free
- **Runtime**: Docker
- **Puerto**: 3000
- **Health Check**: `/healthz`
- **Variables de entorno**:
  - `NODE_ENV=production`
  - `PORT=3000`
  - `DATABASE_URL` (de Railway)

### Frontend Service (`render_web_service.frontend`)
- **Plan**: Free
- **Runtime**: Docker
- **Puerto**: 80 (nginx)
- **Health Check**: `/health`
- **Variables de entorno**:
  - `REACT_APP_API_URL` (URL del backend)

## 🔒 Seguridad

### Variables Sensibles
- `render_api_key` y `database_url` están marcadas como `sensitive = true`
- Nunca commitear `terraform.tfvars` al repositorio
- Usar Terraform Cloud para almacenar secrets de forma segura

### Auto-deploy
- Ambos servicios tienen `auto_deploy = true`
- Render detecta cambios en `main` branch y redespliega automáticamente

## 🧪 Testing Local

Para probar cambios sin aplicarlos:

```bash
terraform plan -out=plan.tfplan
terraform show plan.tfplan
```

## 🚨 Troubleshooting

### Error: "Provider not found"
```bash
terraform init -upgrade
```

### Error: "Invalid API key"
Verifica que tu `RENDER_API_KEY` sea correcto en Terraform Cloud variables.

### Error: "Workspace not found"
Verifica el nombre de tu workspace en `main.tf` bajo el bloque `cloud`.

### Error: "DATABASE_URL invalid"
Asegúrate que el connection string comience con `postgresql://`

## 📚 Documentación Adicional

- [Terraform Render Provider](https://registry.terraform.io/providers/render-oss/render/latest/docs)
- [Render Documentation](https://render.com/docs)
- [Terraform Cloud](https://developer.hashicorp.com/terraform/cloud-docs)

## ✅ Verificación Post-Deployment

Después de un `terraform apply` exitoso:

1. **Verificar outputs:**
   ```bash
   terraform output backend_url
   terraform output frontend_url
   ```

2. **Probar backend:**
   ```bash
   curl https://[backend_url]/healthz
   ```

3. **Abrir frontend en navegador:**
   ```bash
   # Copiar la URL del output
   ```

4. **Verificar en Render Dashboard:**
   - Ve a https://dashboard.render.com
   - Confirma que ambos servicios estén "Live"

## 🔄 Actualización de Infraestructura

Para actualizar la configuración:

1. Modificar archivos `.tf`
2. `terraform plan` para revisar cambios
3. `terraform apply` para aplicar
4. Los servicios se actualizarán automáticamente en Render
