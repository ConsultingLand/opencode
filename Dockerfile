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

CMD ["bun", "run", "--cwd", "packages/app", "start"]
