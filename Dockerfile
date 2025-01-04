FROM node:20-alpine

# Install required packages
RUN apk add --update graphicsmagick tzdata

# Create n8n directory and install n8n globally
USER root
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n && \
    chmod -R 755 /home/node/.n8n && \
    npm install -g npm@latest && \
    npm install n8n@latest -g && \
    npm cache clean --force && \
    ln -s /usr/local/lib/node_modules/n8n/bin/n8n /usr/local/bin/n8n

# Verify installation
RUN n8n --version

# Switch to node user
USER node
WORKDIR /home/node

# Set environment variables
ENV NODE_ENV=production
ENV N8N_EDITOR_BASE_URL=http://localhost:5678
ENV PATH /usr/local/bin:$PATH

EXPOSE 5678

CMD ["n8n", "start"]