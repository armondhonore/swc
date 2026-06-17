# Nexlayer Build Failure Report

**Pipeline:** 19ed2fcf2cd
**Repository:** https://github.com/armondhonore/swc
**Error category:** unknown
**Error summary:** Build failed — see build log for details.

## Build log
```
.../scripts/npm/win32-x64-msvc           |  WARN  Unsupported platform: wanted: {"cpu":["x64"],"os":["win32"],"libc":["any"]} (current: {"os":"linux","cpu":"x64","libc":"musl"})
Scope: all 63 workspace projects
Lockfile is up to date, resolution step is skipped
Packages: +1616
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Progress: resolved 0, reused 0, downloaded 1, added 0

   ╭─────────────────────────────────────────╮
   │                                         │
   │   Update available! 10.33.3 → 11.7.0.   │
   │   Changelog: https://pnpm.io/v/11.7.0   │
   │    To update, run: pnpm add -g pnpm     │
   │                                         │
   ╰─────────────────────────────────────────╯

Progress: resolved 0, reused 0, downloaded 742, added 531
Progress: resolved 0, reused 0, downloaded 923, added 594
Progress: resolved 0, reused 0, downloaded 1361, added 913
Progress: resolved 0, reused 0, downloaded 1417, added 1615
Progress: resolved 0, reused 0, downloaded 1417, added 1616, done

devDependencies:
+ @swc/core 1.15.41 <- packages/core
+ @swc/helpers 0.5.23 <- packages/helpers

packages/core postinstall$ node postinstall.js
packages/core postinstall: Done
. prepare$ husky install . && git config feature.manyFiles true && node ./crates/swc_ecma_preset_env/scripts/copy-data.js
. prepare: sh: git: not found
 ELIFECYCLE  Command failed.
error building image: error building stage: failed to execute command: waiting for process to exit: exit status 1
```

## Repository build artifacts

These are the actual files from the repository. Use these to understand how the project
is SUPPOSED to be built — do not rely solely on the broken Dockerfile below.


### package.json
```
{
    "name": "@swc/workspace",
    "packageManager": "pnpm@10.33.3",
    "private": true,
    "workspaces": [
        "./.github/bot",
        "./.github/swc-ecosystem-ci",
        "./packages/*",
        "./packages/core/scripts/npm/*",
        "./packages/minifier/scripts/npm/*",
        "./packages/html/scripts/npm/*",
        "./packages/react-compiler/scripts/npm/*",
        "./bindings/*",
        "./bindings/binding_core_wasm/*"
    ],
    "scripts": {
        "changelog": "git cliff --output CHANGELOG.md; git cliff --output CHANGELOG-CORE.md --config cliff-core.toml",
        "prepare": "husky install . && git config feature.manyFiles true && node ./crates/swc_ecma_preset_env/scripts/copy-data.js",
        "build": "cd ./packages/core && pnpm build",
        "build:dev": "cd ./packages/core && pnpm build:dev",
        "build:ts": "cd ./packages/core && pnpm build:ts",
        "test": "cd ./packages/core && pnpm test",
        "test:core": "cd ./packages/core && pnpm test",
        "test:minifier": "cd ./packages/minifier && pnpm test",
        "test:html": "cd ./packages/html && pnpm test",
        "test:react-compiler": "cd ./packages/react-compiler && pnpm test"
    },
    "devDependencies": {
        "@babel/compat-data": "^7.28.0",
        "@babel/core": "^7.13.16",
        "@babel/generator": "^7.18.13",
        "@babel/plugin-proposal-class-properties": "^7.13.0",
        "@babel/plugin-proposal-decorators": "^7.13.15",
        "@babel/plugin-proposal-object-rest-spread": "^7.13.8",
        "@babel/preset-env": "^7.13.15",
        "@babel/preset-react": "^7.13.13",
        "@babel/preset-typescript": "^7.13.0",
        "@babel/types": "^7.14.0",
        "@rstest/core": "^0.7.8",
        "@swc/core": "workspace:^",
        "@swc/helpers": "workspace:^",
        "@swc/plugin-jest": "^1.5.117",
        "@taplo/cli": "^0.5.2",
        "@types/jest": "^29.5.11",
        "@types/node": "^20.5.0",
        "@types/terser": "^3.12.0",
        "acorn": "^8.6.0"
... (truncated)
```

### Cargo.toml
```
[workspace]
members = [
  "xtask",
  "bindings/*",
  "crates/*",
  "tools/generate-code",
  "tools/swc-releaser",
]
resolver = "2"

[workspace.package]
edition    = "2021"
license    = "Apache-2.0"
repository = "https://github.com/swc-project/swc.git"


[workspace.dependencies]
# bytecheck version should be in sync with rkyv version. Do not bump individually.
bytecheck = "0.8.0"
rancor    = "0.1.0"
rkyv      = "0.8.16"


Inflector                 = "0.11.4"
allocator-api2            = "0.2.18"
ansi_term                 = "0.12.1"
anyhow                    = "1.0.98"
arbitrary                 = "1"
arrayvec                  = "0.7.4"
ascii                     = "1.1.0"
assert_cmd                = "2.0.17"
assert_fs                 = "1.0.13"
auto_impl                 = "1.2.0"
backtrace                 = "0.3"
base64                    = "0.22.1"
bitflags                  = "2.5.0"
blake3                    = "1.5.4"
browserslist-rs           = "0.19.0"
bumpalo                   = "3.16.0"
bytes-str                 = "0.2.5"
cargo_metadata            = "0.18.1"
changesets                = "0.2.2"
chrono                    = "0.4.38"
codspeed-criterion-compat = "3.0.4"
compact_str               = "0.7.1"
console_error_panic_hook  = "0.1.7"
copyless                  = "0.1.5"
crc                       = "2.1.0"
criterion                 = "0.5.1"
dashmap                   = "6.1.0"
dialoguer                 = "0.10.2"
difference                = "2"
dragonbox_ecma            = "0.1.0"
either                    = "1.10.0"
enumset                   = "1.1.2"
flate2                    = "1.0"
getrandom                 = "0.3.3"
glob                      = "0.3.0"
globset                   = { version = "0.4.16", default-features = false }
hashbrown                 = "0.14.5"
hex                       = "0.4.3"
humansize                 = "2.1.3"
indexmap                  = "2.0.0"
is-macro                  = "0.3.5"
js-sys                    = "0.3.77"
jsonc-parser       
... (truncated)
```

### pnpm-workspace.yaml
```
packages:
  - ./.github/bot
  - ./.github/swc-ecosystem-ci
  - ./packages/*
  - ./packages/core/scripts/npm/*
  - ./packages/minifier/scripts/npm/*
  - ./packages/html/scripts/npm/*
  - ./packages/react-compiler/scripts/npm/*
  - ./bindings/*
  - ./bindings/binding_core_wasm/*

```

### .node-version
```
v20

```


## Last attempted Dockerfile
```dockerfile
FROM mirror.gcr.io/library/node:20-bullseye

# Install essential build tools, LLVM, and git
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

# Setup Rust (MSRV 1.73)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.73
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup toolchain install nightly && rustup default nightly

# Use Corepack for pnpm 10.33.3
RUN npm install -g corepack@latest && corepack enable && corepack prepare pnpm@10.33.3 --activate

WORKDIR /repo

# Copy all files first
COPY . .

# Fix for the specific build failure: 
# The 'prepare' script fails because it calls 'husky install' and 'git config', 
# but pnpm by default runs lifecycle scripts. 
# We use --ignore-scripts to skip husky/git-config during install.
RUN pnpm install --no-frozen-lockfile --ignore-scripts

# Manually run the only critical build-time data script required for the compiler to function
RUN node ./crates/swc_ecma_preset_env/scripts/copy-data.js || true

# Build the core bindings with high heap size
ENV NODE_OPTIONS="--max-old-space-size=8192"
RUN pnpm run build

# Health check shim
RUN npm install -g serve

EXPOSE 8080

CMD ["sh", "-c", "echo 'SWC build worker active' > index.html && serve -s . -l 8080"]
```

## Last attempted nexlayer.yaml
```yaml

```

## Instructions for frontier model

CRITICAL: Before writing any fix, read the repository build artifacts above and answer:
1. What language/runtime does this project use? (go.mod, package.json, pom.xml, Cargo.toml, requirements.txt)
2. What is the actual build command? (package.json scripts.build, Makefile targets, pom.xml goals, gradle tasks)
3. What is the actual start command? (package.json scripts.start, Makefile run target, Procfile)
4. What port does it serve? (EXPOSE, ENV PORT=, --port flag, framework default)
5. What dependencies does it need at runtime? (docker-compose.yml services, .env.example vars)

Then create a correct Dockerfile from scratch based on your analysis:
- All FROM base images must be standard public images (library/, gcr.io, ghcr.io, etc.)
- Use `mirror.gcr.io/library/` prefix for Docker Hub official images (node:*, python:*, golang:*, etc.)
- DO NOT copy broken steps from the "last attempted Dockerfile" — build from what the repo actually needs

Fix nexlayer.yaml if needed:
- Inter-pod service references MUST use `${podName:port}` template syntax
- Example: `DATABASE_URL: postgresql://user:pass@${postgres:5432}/db`

Create a file named `nexlayer_fix.md` on THIS branch (`nexlayer`) with this structure:

---
# Nexlayer Fix

## Fixed Dockerfile
```dockerfile
<your fixed Dockerfile>
```

## Fixed nexlayer.yaml
```yaml
<your fixed nexlayer.yaml>
```

## Notes
<explain: what build command you found, what was wrong with the previous Dockerfile, what you changed and why>
---

Nexlayer detects `nexlayer_fix.md` on the next pipeline run and applies your fixes automatically.
