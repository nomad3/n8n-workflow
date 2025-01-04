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