# Nexlayer working build fix

This file is the authoritative, pinned build solution for this repo. Nexlayer uses it verbatim on every run and will not override it. If a future build with this fix fails, Nexlayer appends/updates it rather than regenerating.

## CRITICAL BUILD CONSTRAINTS

1. **`path: /` is required on the pod** — Nexlayer deploy phase rejects the config without it, even though the YAML validator passes.

2. **CMD must explicitly bind to `tcp://0.0.0.0:8080`** — bare `-l 8080` may bind to localhost only, causing health checks to time out.

3. **Rust toolchain must match `rust-toolchain` file (`nightly-2026-04-10`)** — do NOT use `1.73` stable or unversioned nightly; napi-rs build will fail with type errors on the wrong toolchain.

4. **Serve only `/app/public`** — do NOT `serve -s . -l 8080` from `/repo`; that exposes the entire Rust source tree and all compilation artifacts.

## Fixed Dockerfile

```dockerfile
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
```

## Fixed nexlayer.yaml

```yaml
application:
  name: calm-vale-swc
  pods:
    - name: swc-build-worker
      image: "# filled by pipeline"
      path: /
      servicePorts:
        - 8080
      vars:
        NODE_OPTIONS: "--max-old-space-size=8192"
```

## Notes

Build details:
- `--ignore-scripts` skips the root `prepare` script (husky + git config) which fails in Docker — the only essential part is `copy-data.js` which we run manually
- `pnpm run build` → `cd packages/core && pnpm build` → napi-rs Rust compilation (~20-30 min, needs nightly-2026-04-10)
- Output is a native `.node` binding at `packages/core/`
- The web server is a minimal health-check placeholder only; SWC is a compiler library with no HTTP interface
- `serve` from the `serve` npm package is used for the static placeholder; `npx serve` avoids a global install step
