FROM node:22-slim

# Installiere Build-Tools für native Dependencies (tree-sitter, node-pty, etc.)
RUN apt-get update && apt-get install -y \
    python3 \
    python3-distutils \
    make \
    g++ \
    gcc \
    git \
    curl \
    libc6-dev \
    libstdc++-12-dev \
    && rm -rf /var/lib/apt/lists/*

# Installiere bun global
RUN npm install -g bun

# Setze Working Directory
WORKDIR /app

# Kopiere Package-Files zuerst (für Docker-Layer-Caching)
COPY package.json bun.lockb* ./
COPY packages/ ./packages/

# Installiere node-gyp global und lokal
RUN npm install -g node-gyp
RUN npm install node-gyp

# Installiere Dependencies mit bun (trusted dependencies erlauben)
RUN bun install --trusted

# Kopiere den Rest des Codes
COPY . .

# Build (anpassen je nachdem, welches Package du deployen willst)
# Für die Web-App:
RUN bun run build

# Expose Port (anpassen je nach App)
EXPOSE 3000

# Start
CMD ["bun", "run", "start"]
