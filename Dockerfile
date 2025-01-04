FROM n8nio/n8n:latest

# Variables de entorno básicas
ENV NODE_ENV=production
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

# Configuración de n8n
ENV N8N_PORT=5678
ENV DB_TYPE=postgresdb
ENV DB_POSTGRESDB_SCHEMA=public

USER root
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n && \
    chmod 700 /home/node/.n8n

USER node
EXPOSE 5678

VOLUME /home/node/.n8n

# Iniciar n8n con configuración específica
CMD ["n8n", "start", "--tunnel"]