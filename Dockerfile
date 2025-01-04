FROM node:18-alpine

# Install required packages
RUN apk add --update graphicsmagick tzdata

# Create n8n directory
USER root
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n && \
    chmod -R 755 /home/node/.n8n

# Switch to node user
USER node
WORKDIR /home/node

# Install n8n
RUN npm install n8n -g

# Set environment variables
ENV NODE_ENV=production
ENV N8N_EDITOR_BASE_URL=http://localhost:5678

EXPOSE 5678

CMD ["n8n", "start"]