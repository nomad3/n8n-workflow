FROM n8nio/n8n:latest

ENV DB_TYPE=postgresdb
ENV DB_POSTGRESDB_HOST=tu-host
ENV DB_POSTGRESDB_DATABASE=n8n
ENV DB_POSTGRESDB_USER=usuario
ENV DB_POSTGRESDB_PASSWORD=contraseña

# Puerto por defecto de n8n
EXPOSE 5678

# Volumen para persistir los datos
VOLUME /root/.n8n 