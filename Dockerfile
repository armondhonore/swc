FROM mirror.gcr.io/library/node:20-bullseye

# Install essential build tools and LLVM (required for SWC native bindings)
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

# Setup Rust (MSRV 1.73) and ensure nightly is available for intrinsic features
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.73
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup toolchain install nightly && rustup default nightly

# Use Corepack for pnpm 10.33.3 as per packageManager signal
RUN npm install -g corepack@latest && corepack enable && corepack prepare pnpm@10.33.3 --activate

WORKDIR /repo

# Copy all files including .npmrc (crucial for hoisted linker)
COPY . ./

# Install dependencies without lifecycle scripts to avoid husky/prepare failures
# --no-frozen-lockfile is mandatory for pnpm 10 on this platform
RUN pnpm install --no-frozen-lockfile --ignore-scripts

# Build the core bindings. Use high heap size to prevent OOM during Rust compilation
ENV NODE_OPTIONS="--max-old-space-size=8192"
RUN pnpm run build

# SWC is a library/worker. To satisfy Nexlayer health checks, we serve a static page.
RUN npm install -g serve

EXPOSE 8080

CMD ["sh", "-c", "echo 'SWC build worker active' > index.html && serve -s . -l 8080"]
