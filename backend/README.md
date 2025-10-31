# Backend

API RESTful construida con Node.js y Express para gestión de usuarios.

## Estructura
```
backend/
├── src/
│   ├── index.js          # Entry point
│   ├── routes/           # API routes
│   ├── controllers/      # Business logic
│   └── models/           # Database models
├── tests/                # Unit & integration tests
├── Dockerfile            # Multi-stage Docker build
├── .eslintrc.json        # ESLint config
└── package.json          # Dependencies
```

## Endpoints
- `GET /healthz` - Health check
- `GET /readiness` - Readiness check
- `GET /users` - Listar usuarios
- `POST /users` - Crear usuario
- `GET /users/:id` - Obtener usuario
- `PUT /users/:id` - Actualizar usuario
- `DELETE /users/:id` - Eliminar usuario
- `GET /metrics` - Prometheus metrics

## Variables de Entorno
Ver `.env.example` para configuración requerida.
