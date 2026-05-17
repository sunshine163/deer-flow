# Copilot Onboarding Instructions for DeerFlow (Gateway / Backend Fork)

Use this file as the default operating guide for this repository. Follow it first, and only search the codebase when this file is incomplete or incorrect.

## 1) Repository Summary

DeerFlow backend: Python 3.12, LangGraph agent runtime embedded in the FastAPI Gateway, sandbox/tools, memory, MCP, skills.

- **No bundled `frontend/`** in this fork — integrate via HTTP at `http://localhost:8001`.
- **Local dev**: `cd backend && make dev` or root `make dev` (Git Bash on Windows).
- **Docker dev**: `make docker-init` → `make docker-start`.
- **Docker prod**: `make up` / `make down`.

## 2) Runtime and Toolchain Requirements

- Python `>=3.12`
- `uv` package manager
- Docker (optional, for containerized dev/prod or AIO sandbox)
- Git Bash on Windows for root-level `make dev` / `make docker-*`

Run backend commands from `backend/` unless noted.

## 3) Build / Test / Lint / Run

### Bootstrap

```bash
make check      # verifies uv is installed
make config     # first-time config.yaml from template (aborts if exists)
make install    # uv sync + pre-commit hooks
make setup      # interactive wizard (TTY required)
```

### Backend validation (CI parity)

```bash
cd backend
make lint
make test
```

### Run Gateway locally

```bash
cd backend && make dev
# → http://localhost:8001  (GET /health, /docs, /api/*)
```

From repo root (bash):

```bash
make dev
make stop
```

### Docker

```bash
make docker-init
make docker-start    # dev stack, port 8001
make docker-logs-gateway
make up              # production stack
make docker-logs-prod
make down
```

## 4) Key Paths

- `config.yaml` — models, tools, sandbox (project root)
- `extensions_config.json` — MCP servers and skills
- `backend/app/gateway/` — FastAPI app and routers
- `backend/packages/harness/deerflow/` — agent runtime (`deerflow.*`)
- `skills/` — public and custom skills
- `scripts/serve.sh` — local Gateway launcher
- `scripts/docker.sh` / `scripts/deploy.sh` — Docker dev / prod

## 5) PR Checklist

1. `cd backend && make lint && make test`
2. Update docs when changing startup, ports, or config layout
3. Do not reintroduce `frontend/` or nginx compose services without an explicit product decision
