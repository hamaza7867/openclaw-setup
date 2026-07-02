FROM node:22-slim

# Install core runtime dependencies for background syncs
RUN apt-get update && apt-get install -y git curl procps && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install OpenClaw globally and mirror dependencies locally
RUN npm install -g openclaw@latest
COPY package*.json ./
RUN npm install --omit=dev

# Pre-stage the runtime config path
RUN mkdir -p /root/.openclaw
COPY openclaw.json /root/.openclaw/openclaw.json

# Expose internal Control plane and Canvas Webhook Bridge ports
EXPOSE 18789
EXPOSE 18791

CMD ["openclaw", "gateway", "start"]
