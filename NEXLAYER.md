# Nexlayer — swc

<!-- nexlayer:meta version=1 analyzed=2026-06-16T21:07:11Z repo=https://github.com/armondhonore/swc branch=main -->

> **For AI agents (Claude Code, Cursor, Gemini CLI, Copilot):**
> This file is the **project context** for this Nexlayer deployment — tech stack, env vars, secrets, live URL.
> For full platform detail (nexlayer.yaml schema, Dockerfile rules, CI/CD, task recipes) read **`nexlayer.skills`** in this repo.
>
> **Critical rules (full detail in `nexlayer.skills`):**
> - Inter-pod refs: `${podName:port}` only — never `localhost` or bare hostnames
> - Docker Hub images: prefix with `mirror.gcr.io/library/` — bare tags fail on the cluster
> - Secrets: set in the Nexlayer dashboard — never commit to `nexlayer.yaml` or Dockerfile
>
> **This file:** `agent-managed` sections update automatically. `user-editable` sections (Local Development Setup, Nexlayer Deployment Plan, Build Notes) are yours — preserved across re-analysis.

## Project Summary
<!-- nexlayer:section agent-managed=project_summary -->
SWC (Speedy Web Compiler) is a high-performance TypeScript/JavaScript compiler and toolset written in Rust, designed to replace Babel for faster compilation and minification.
<!-- nexlayer:end -->

## Technology Stack
<!-- nexlayer:section agent-managed=tech_stack -->
| Name | Kind | Version | Detected From |
|------|------|---------|---------------|
| Rust | language | 1.73 | README.md |
| Node.js | language | 20 | .node-version |
| pnpm | tool | 10.33.3 | package.json |
| napi-rs | build | 3.2.0 | packages/core/package.json |
<!-- nexlayer:end -->

## Repository Structure
<!-- nexlayer:section agent-managed=structure_map -->
- crates/ — Rust core logic and compiler crates
- packages/core — Primary Node.js bindings for the core compiler
- packages/html — HTML minification package
- packages/minifier — JS/TS minification package
- bindings/ — NAPI-RS and WASM bridge definitions
- xtask — Rust automation tasks
<!-- nexlayer:end -->

## External Services Required
<!-- nexlayer:section agent-managed=external_deps -->
_No external services detected._
<!-- nexlayer:end -->

## Local Development Setup
<!-- nexlayer:section user-editable=local_setup -->
### Prerequisites

- Rust 1.73+
- Node.js v20
- pnpm v10

### Steps

1. `pnpm install` — Install workspace dependencies
2. `pnpm build` — Build core packages (requires Rust toolchain)

<!-- nexlayer:end -->

## Nexlayer Setup
<!-- nexlayer:section agent-managed=nexlayer_setup -->
### Pod Environment Variables

| Pod | Variable | Value | Kind |
|-----|----------|-------|------|
| `swc-build-worker` | `NODE_OPTIONS` | `"--max-old-space-size=8192"` | plain |

### nexlayer.yaml

```yaml
application:
  name: calm-vale-swc
  pods:
    - name: swc-build-worker
      image: "# filled by pipeline"
      servicePorts:
        - 8080
      vars:
        NODE_OPTIONS: "--max-old-space-size=8192"
```

<!-- nexlayer:end -->

## Nexlayer Deployment Plan
<!-- nexlayer:section user-editable=deployment_plan -->
### Pod Topology

| Pod | Image | Port | Role |
|-----|-------|------|------|
| swc-build-agent | mirror.gcr.io/library/node:20-alpine | 8080 | worker |

### Deployment notes

- SWC is primarily a library/toolset rather than a long-running server application; deployment here represents a build agent or tool-server role.
- Rust compilation must occur during the build phase of the image using mirror.gcr.io/library/rust:alpine before switching to the node:20-alpine runtime.

<!-- nexlayer:end -->

## Build Notes
<!-- nexlayer:section user-editable=build_notes -->
<!-- Add notes for future builds here — preserved across re-analysis -->
<!-- nexlayer:end -->

## Nexlayer Configuration
<!-- nexlayer:section agent-managed=nexlayer_config -->
**Last deployed:** 2026-06-16T23:17:10Z  
**Live URL:** https://calm-vale-swc.nexlayer.ai  
**Runtime:** node · **Port:** 8080  
**Deploy branch:** main  

```yaml
application:
  name: calm-vale-swc
  pods:
    - name: swc-build-worker
      image: "# filled by pipeline"
      servicePorts:
        - 8080
      vars:
        NODE_OPTIONS: "--max-old-space-size=8192"
```
<!-- nexlayer:end -->

## Build History
<!-- nexlayer:section agent-managed=build_history -->
| Date | Status | Notes |
|------|--------|-------|
| 2026-06-16T21:07:11Z | analyzed | initial repo analysis |
| 2026-06-16T23:17:10Z | success | deployed https://calm-vale-swc.nexlayer.ai |
<!-- nexlayer:end -->
