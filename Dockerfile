FROM node:22-slim

# Installiere ALLE Build-Tools inkl. Python
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python-is-python3 \
    make \
    g++ \
    gcc \
    git \
    curl \
    libc6-dev \
    && rm -rf /var/lib/apt/lists/*

# Setze Python-Pfad explizit für node-gyp
ENV PYTHON=/usr/bin/python3

# Installiere bun
RUN npm install -g bun

WORKDIR /app

# Kopiere Root-Package-Files
COPY package.json ./
COPY bun.lockb* ./

# Kopiere Workspace package.json Files (für Caching)
COPY packages/core/package.json ./packages/core/
COPY packages/opencode/package.json ./packages/opencode/
COPY packages/app/package.json ./packages/app/
COPY packages/console/app/package.json ./packages/console/app/
COPY packages/desktop/package.json ./packages/desktop/
COPY packages/sdk/js/package.json ./packages/sdk/js/
COPY packages/slack/package.json ./packages/slack/

# Installiere node-gyp
RUN npm install -g node-gyp

# Installiere Dependencies
RUN bun install --trusted

# Kopiere den Rest
COPY . .

# Build
RUN bun run build

EXPOSE 3000

CMD ["bun", "run", "start"]
