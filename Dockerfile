FROM mirror.gcr.io/library/node:20-bullseye

RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    g++ \
    make \
    python3 \
    git \
    clang \
    llvm \
    llvm-dev \
    && rm -rf /var/lib/apt/lists/*

# Install pinned Rust nightly toolchain matching rust-toolchain file
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly-2026-04-10
ENV PATH="/root/.cargo/bin:${PATH}"

RUN npm install -g corepack@latest && corepack enable && corepack prepare pnpm@10.33.3 --activate

WORKDIR /repo

COPY . ./

RUN pnpm install --no-frozen-lockfile --ignore-scripts

RUN node ./crates/swc_ecma_preset_env/scripts/copy-data.js

ENV NODE_OPTIONS="--max-old-space-size=8192"
RUN pnpm run build

RUN mkdir -p /app/public && echo '{"name":"@swc/core","status":"ok"}' > /app/public/index.html

EXPOSE 8080

CMD ["npx", "serve", "-l", "tcp://0.0.0.0:8080", "/app/public"]