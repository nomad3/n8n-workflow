FROM n8nio/n8n:latest

USER root
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n && \
    chmod 700 /home/node/.n8n

USER node
EXPOSE 5678
VOLUME /home/node/.n8n

# Esta es la forma oficial de iniciar n8n en su imagen Docker
CMD ["tini", "--", "n8n", "start"]