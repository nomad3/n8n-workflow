FROM n8nio/n8n:latest

ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
ENV PATH /usr/local/lib/node_modules/n8n/bin:$PATH

USER root
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n && \
    chmod 700 /home/node/.n8n && \
    npm install -g n8n

USER node
EXPOSE 5678

VOLUME /home/node/.n8n

ENTRYPOINT ["n8n"]
CMD ["start"]