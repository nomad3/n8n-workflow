# n8n Workflow Setup

Este repositorio contiene la configuración para ejecutar n8n en un entorno de desarrollo usando Docker.

## Requisitos Previos

- Docker
- Docker Compose
- Git
- Google Cloud Platform (GCP) VM instance
- Puerto 5678 abierto en el firewall

## Estructura del Proyecto

```
n8n-workflow/
├── docker-compose.yml
├── Dockerfile
├── workflows/
│   └── modo_bestia.json
├── n8n_data/
│   └── config
└── README.md
```

## Configuración Rápida

1. Clonar el repositorio:
```bash
git clone https://github.com/tu-usuario/n8n-workflow.git
cd n8n-workflow
```

2. Configurar el archivo docker-compose.yml:
```yaml
version: '3.8'

services:
  n8n:
    build: 
      context: .
      dockerfile: Dockerfile
    ports:
      - "5678:5678"
    environment:
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=n8n
      - DB_POSTGRESDB_USER=n8n
      - DB_POSTGRESDB_PASSWORD=n8n_password
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin@admin.com
      - N8N_BASIC_AUTH_PASSWORD=adminpassword
      - N8N_HOST=0.0.0.0
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - N8N_EDITOR_BASE_URL=http://34.134.38.96:5678
      - WEBHOOK_URL=http://34.134.38.96:5678/
      - N8N_SECURE_COOKIE=false
    volumes:
      - n8n_data:/home/node/.n8n
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    restart: unless-stopped

  postgres:
    image: postgres:13-alpine
    environment:
      - POSTGRES_USER=n8n
      - POSTGRES_PASSWORD=n8n_password
      - POSTGRES_DB=n8n
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U n8n"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped

  redis:
    image: redis:6-alpine
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 3
    restart: unless-stopped

volumes:
  n8n_data:
  postgres_data:
  redis_data:
```

3. Crear el Dockerfile:
```dockerfile
FROM node:20-alpine

# Install required packages
RUN apk add --update graphicsmagick tzdata

# Create n8n directory and set permissions
USER root
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n && \
    chmod -R 755 /home/node/.n8n

# Switch to node user for npm install
USER node
WORKDIR /home/node

# Install n8n
RUN npm install n8n@latest && \
    npm cache clean --force

# Set environment variables
ENV NODE_ENV=production
ENV N8N_EDITOR_BASE_URL=http://localhost:5678
ENV PATH /home/node/node_modules/.bin:$PATH

EXPOSE 5678

# Verify installation
RUN n8n --version

CMD ["n8n", "start"]
```

4. Iniciar los servicios:
```bash
docker-compose up -d
```

## Acceso

- **URL**: http://34.134.38.96:5678
- **Usuario**: admin@admin.com
- **Contraseña**: adminpassword

## Comandos Útiles

```bash
# Ver logs
docker-compose logs -f

# Reiniciar servicios
docker-compose restart

# Detener servicios
docker-compose down

# Reconstruir n8n (después de cambios)
docker-compose build --no-cache n8n
docker-compose up -d
```

## Volúmenes Persistentes

- **n8n_data**: Configuración de n8n
- **postgres_data**: Base de datos PostgreSQL
- **redis_data**: Caché Redis

## Consideraciones para Producción

Para un entorno de producción, se recomienda:

1. Implementar HTTPS/SSL
2. Habilitar cookies seguras (`N8N_SECURE_COOKIE=true`)
3. Usar contraseñas más seguras
4. Configurar backups regulares
5. Implementar monitoreo
6. Usar un dominio personalizado

## Solución de Problemas

1. Si no puedes acceder al servicio:
   - Verificar que el puerto 5678 está abierto
   - Comprobar los logs con `docker-compose logs -f`
   - Verificar que todos los contenedores están corriendo con `docker-compose ps`

2. Si hay problemas de permisos:
   - Verificar los permisos en la carpeta n8n_data
   - Comprobar los logs de n8n

## Mantenimiento

- Realizar backups regulares de la base de datos
- Mantener las imágenes Docker actualizadas
- Monitorear el uso de recursos
- Revisar los logs periódicamente

## Referencias

- [Documentación oficial de n8n](https://docs.n8n.io/)
- [Docker Hub - n8n](https://hub.docker.com/r/n8nio/n8n)
- [GitHub - n8n](https://github.com/n8n-io/n8n)