FROM node:22-slim

# Force non-interactive configuration to stop apt-get from waiting for prompt inputs
ENV DEBIAN_FRONTEND=noninteractive

# Install only the bare minimum system utilities and immediately clear the cache
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Ensure global npm packages don't run into cloud permission boundary errors
ENV NPM_CONFIG_PREFIX=/root/.npm-global
ENV PATH=$PATH:/root/.npm-global/bin

# Install OpenClaw globally without bulky dev dependencies
RUN npm install -g openclaw@latest --omit=dev

# Pre-stage directory mapping for our AgentRouter configuration
RUN mkdir -p /root/.openclaw
COPY openclaw.json /root/.openclaw/openclaw.json

COPY package*.json ./
RUN npm install --omit=dev

EXPOSE 18789
EXPOSE 18791

CMD ["openclaw", "gateway", "start"]
