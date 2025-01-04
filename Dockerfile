FROM n8nio/n8n:latest

ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

USER root
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n && \
    chmod 700 /home/node/.n8n

USER node
EXPOSE 5678

VOLUME /home/node/.n8n

CMD ["n8n", "start"]