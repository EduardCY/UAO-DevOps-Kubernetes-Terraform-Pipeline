# 📝 Instrucciones de Configuración Manual

Este archivo contiene todos los pasos manuales que debes realizar en los diferentes servicios.

## ⚠️ IMPORTANTE: Orden de Ejecución

Realiza estas configuraciones EN ORDEN antes de ejecutar los pipelines.

---

## 1️⃣ GitHub Repository Setup

### 1.1 Crear Repositorio
- ✅ Ya creado: `Final_DevOps_Proyecto`
- ✅ Asegurar que es público (o privado con permisos adecuados)

### 1.2 Habilitar Issues
1. Ve a **Settings** del repositorio
2. En **Features**, marca ✅ **Issues**
3. Guardar cambios

### 1.3 Configurar Branch Protection Rules
1. Ve a **Settings → Branches**
2. Click en **Add rule**
3. Branch name pattern: `main`
4. Configurar:
   - ✅ Require a pull request before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging
   - ✅ Require linear history
5. Click **Create**

### 1.4 Configurar GitHub Actions Permissions
1. Ve a **Settings → Actions → General**
2. En **Actions permissions**:
   - Seleccionar: ✅ Allow all actions and reusable workflows
3. En **Workflow permissions**:
   - Seleccionar: ✅ Read and write permissions
   - ✅ Allow GitHub Actions to create and approve pull requests
4. **Save**

---

## 2️⃣ Railway (PostgreSQL Database)

### 2.1 Crear Cuenta
1. Ve a https://railway.app
2. Click en **Start a New Project**
3. Login con GitHub (autenticación OAuth)

### 2.2 Provisionar PostgreSQL
1. En el dashboard, click **+ New Project**
2. Selecciona **Provision PostgreSQL**
3. Esperar a que se cree (1-2 minutos)

### 2.3 Obtener DATABASE_URL
1. Click en el servicio PostgreSQL creado
2. Ve a la pestaña **Variables**
3. Buscar `DATABASE_URL`
4. **Copiar el valor completo** (ejemplo: `postgresql://postgres:PASSWORD@host:5432/railway`)

### 2.4 Configurar Base de Datos
1. En el mismo panel, ve a **Query**
2. Ejecuta el siguiente SQL:
```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
3. Verificar: `SELECT * FROM users;`

### ✅ Guardar para más tarde:
```
DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@containers-us-west-XXX.railway.app:XXXX/railway
```

---

## 3️⃣ Render (Application Hosting)

### 3.1 Crear Cuenta
1. Ve a https://render.com
2. Click en **Get Started**
3. Login con GitHub

### 3.2 Generar API Key
1. En el dashboard, click en tu avatar (arriba derecha)
2. **Account Settings**
3. En el menú izquierdo: **API Keys**
4. Click **Create API Key**
5. Nombre: `DevOps-Pipeline-Key`
6. **Copiar el key** (solo se muestra una vez)

### ✅ Guardar:
```
RENDER_API_KEY=rnd_XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

### 3.3 Nota Importante
❌ **NO crear servicios manualmente** en Render
✅ Terraform los creará automáticamente después

---

## 4️⃣ Terraform Cloud (State Management)

### 4.1 Crear Cuenta
1. Ve a https://app.terraform.io
2. **Sign up** con email o GitHub
3. Verificar email

### 4.2 Crear Organización
1. En el wizard, click **Create an organization**
2. Nombre: `devops-crud-org` (o el que prefieras)
3. Email: tu email
4. **Create organization**

### 4.3 Crear Workspace
1. Click **+ New Workspace**
2. Seleccionar: **API-driven workflow**
3. Nombre: `crud-devops-prod`
4. **Create workspace**

### 4.4 Generar API Token
1. En tu perfil (arriba derecha) → **User Settings**
2. **Tokens** en el menú izquierdo
3. Click **Create an API token**
4. Descripción: `GitHub Actions Token`
5. **Generate token**
6. **Copiar el token** (solo se muestra una vez)

### ✅ Guardar:
```
TF_API_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.atlasv1.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

### 4.5 Configurar Variables en Workspace
1. Ve al workspace `crud-devops-prod`
2. **Variables** tab
3. Agregar las siguientes **Terraform variables**:
   - Key: `render_api_key`, Value: `[tu RENDER_API_KEY]`, ✅ Sensitive
   - Key: `database_url`, Value: `[tu DATABASE_URL]`, ✅ Sensitive

---

## 5️⃣ Grafana Cloud (Monitoring)

### 5.1 Crear Cuenta
1. Ve a https://grafana.com
2. Click **Create free account**
3. Completa el registro

### 5.2 Crear Stack
1. En el dashboard, click **Create a stack**
2. Stack name: `devops-crud-monitoring`
3. Región: Seleccionar la más cercana
4. **Create stack**
5. Esperar a que se provisione (1-2 minutos)

### 5.3 Configurar Prometheus Data Source (OPCIONAL)
⚠️ **NOTA**: Grafana Cloud ya incluye Prometheus integrado. Solo necesitas esto si quieres conectar un Prometheus externo.

**Para usar el Prometheus incluido en Grafana Cloud:**
1. En tu stack, ve a **Home → Connections → Data sources**
2. Verás **Prometheus (default)** ya configurado
3. Click en él para ver la configuración
4. La URL será automática: `https://prometheus-XXX.grafana.net`
5. **Ya está listo para usar** ✅

**Si necesitas crear uno nuevo:**
1. Click **Add new data source**
2. Seleccionar **Prometheus**
3. Name: `Prometheus-Render` (si vas a conectar tu app)
4. URL: Dejar vacío por ahora (se configurará con el endpoint de tu app después)
5. **Save & Test** (fallará hasta que despliegues la app)

### 5.4 Generar API Key
1. En el menú izquierdo: **Administration → API Keys**
2. Click **Add API key**
3. Key name: `devops-pipeline-key`
4. Role: **Editor**
5. **Add**
6. **Copiar el API key** (solo se muestra una vez)

### 5.5 Obtener Stack URL y Configurar Remote Write (Importante)
1. En el menú principal, copiar la URL de tu stack
2. Formato: `https://XXXXX.grafana.net`

**Para enviar métricas desde tu app:**
1. Ve a **Home → Connections → Add new connection**
2. Busca **Prometheus** y selecciona **Via Prometheus remote_write**
3. Copia los valores:
   - **Remote Write Endpoint**: `https://prometheus-XXX.grafana.net/api/prom/push`
   - **Username / Instance ID**: Tu user ID (número)
   - **Password**: Necesitarás generar un token

4. Para generar el token:
   - Ve a **Administration → Access Policies**
   - Click **Create access policy**
   - Name: `prometheus-push`
   - Scopes: ✅ `metrics:write`, ✅ `metrics:read`
   - **Create**
   - Luego **Add token**
   - Name: `app-metrics-token`
   - **Generate token**
   - **Copiar el token** (solo se muestra una vez)

### ✅ Guardar:
```
GRAFANA_URL=https://XXXXX.grafana.net
GRAFANA_API_KEY=glsa_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
GRAFANA_PROMETHEUS_ENDPOINT=https://prometheus-XXX.grafana.net/api/prom/push
GRAFANA_PROMETHEUS_USER=123456
GRAFANA_PROMETHEUS_TOKEN=glc_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

**Nota**: Por ahora solo necesitas GRAFANA_URL y GRAFANA_API_KEY para la Fase 3. Las credenciales de Prometheus se configurarán en la Fase 7 (Monitoring).

---

## 6️⃣ UptimeRobot (Uptime Monitoring)

### 6.1 Crear Cuenta
1. Ve a https://uptimerobot.com
2. Click **Register for FREE**
3. Verificar email

### 6.2 Configurar Monitor (DESPUÉS del primer deploy)
1. En el dashboard, click **+ Add New Monitor**
2. Monitor Type: **HTTP(s)**
3. Friendly Name: `CRUD App Production`
4. URL: `[URL de tu app en Render - obtener después]`
5. Monitoring Interval: **5 minutes** (free tier)
6. Monitor Timeout: **30 seconds**
7. **Create Monitor**

### 6.3 Configurar Alertas
1. Click en el monitor creado
2. **Alert Contacts**
3. Agregar tu email
4. Configurar: Alert cuando esté **Down**

### ⏰ Hacer esto DESPUÉS del primer deployment exitoso

---

## 7️⃣ GitHub Secrets Configuration

Ahora que tienes todos los valores, agrégalos a GitHub:

### 7.1 Acceder a Secrets
1. Ve a tu repositorio en GitHub
2. **Settings → Secrets and variables → Actions**
3. Click **New repository secret**

### 7.2 Agregar Secrets (uno por uno)

| Secret Name | Valor | Descripción |
|-------------|-------|-------------|
| `DATABASE_URL` | `postgresql://postgres:...` | Connection string de Railway |
| `RENDER_API_KEY` | `rnd_...` | API Key de Render |
| `TF_API_TOKEN` | `XXXX.atlasv1.XXXX` | Token de Terraform Cloud |
| `GRAFANA_URL` | `https://XXXXX.grafana.net` | URL del stack de Grafana |
| `GRAFANA_API_KEY` | `glsa_...` | API Key de Grafana |

Para cada uno:
1. Click **New repository secret**
2. Name: [nombre del secret]
3. Secret: [valor copiado]
4. **Add secret**

---

## 8️⃣ Verificación Final

### ✅ Checklist de Configuración

- [ ] GitHub: Repository público/privado configurado
- [ ] GitHub: Issues habilitados
- [ ] GitHub: Branch protection en `main`
- [ ] GitHub: Actions permissions configurados
- [ ] Railway: PostgreSQL provisionado
- [ ] Railway: Tabla `users` creada
- [ ] Render: Cuenta creada
- [ ] Render: API Key generado
- [ ] Terraform Cloud: Organización creada
- [ ] Terraform Cloud: Workspace `crud-devops-prod` creado
- [ ] Terraform Cloud: Variables configuradas en workspace
- [ ] Grafana Cloud: Stack creado
- [ ] Grafana Cloud: Prometheus configurado
- [ ] Grafana Cloud: API Key generado
- [ ] UptimeRobot: Cuenta creada (monitor se crea después)
- [ ] GitHub Secrets: 5 secrets agregados

### 🧪 Test de Conexión Railway
```bash
# Instalar psql si no lo tienes
# Windows: https://www.postgresql.org/download/windows/
# macOS: brew install postgresql
# Linux: sudo apt-get install postgresql-client

# Conectar a Railway
psql "postgresql://postgres:PASSWORD@HOST:PORT/railway"

# Verificar tabla
\dt
SELECT * FROM users;
```

---

## 🚨 Troubleshooting

### Railway no se conecta
- Verificar que el DATABASE_URL sea correcto
- Asegurar que la tabla `users` existe
- Check firewall settings

### Render API Key no funciona
- Verificar que copiaste el key completo
- Regenerar si es necesario

### Terraform Cloud falla
- Verificar que el workspace existe
- Check que las variables estén marcadas como "Sensitive"
- Validar formato del TF_API_TOKEN

### Grafana no muestra datos
- Asegurar que Prometheus está configurado
- Verificar que tu app expone `/metrics`
- Wait 5-10 minutos para primera data

---

## 📞 Recursos de Ayuda

- **Railway Docs**: https://docs.railway.app
- **Render Docs**: https://render.com/docs
- **Terraform Cloud**: https://developer.hashicorp.com/terraform/cloud-docs
- **Grafana Docs**: https://grafana.com/docs
- **GitHub Actions**: https://docs.github.com/actions

---

## ✅ Siguiente Paso

Una vez completadas TODAS estas configuraciones, puedes proceder con:
- Fase 2: Desarrollo de la aplicación CRUD
- Los pipelines de CI/CD funcionarán automáticamente

**¡No olvides guardar todos tus secrets de forma segura!**
