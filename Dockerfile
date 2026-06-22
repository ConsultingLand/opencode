FROM node:22-slim

RUN apt-get update && apt-get install -y \
    python3 python3-pip python-is-python3 make g++ gcc git curl libc6-dev \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHON=/usr/bin/python3

RUN npm install -g bun

WORKDIR /app

COPY . .

RUN npm install -g node-gyp
RUN bun install --trusted

EXPOSE 3000

# Erstelle Config mit Kimi K2.7 direkt im Image
RUN mkdir -p /root/.config/opencode && \
    echo '{
  "provider": {
    "moonshot": {
      "name": "Moonshot AI",
      "options": {
        "baseURL": "https://api.moonshot.cn/v1",
        "apiKey": "${MOONSHOT_API_KEY}"
      },
      "models": {
        "kimi-k2-7": {
          "name": "Kimi K2.7"
        }
      }
    }
  },
  "model": "moonshot/kimi-k2-7"
}' > /root/.config/opencode/opencode.json

CMD ["bun", "run", "--cwd", "packages/app", "start"]
