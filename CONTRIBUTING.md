# Contributing to DeerFlow

Thank you for your interest in contributing to DeerFlow! This guide will help you set up your development environment and understand our development workflow.

## Development Environment Setup

We offer two development environments. **Docker is recommended** for the most consistent and hassle-free experience.

### Option 1: Docker Development (Recommended)

Docker provides a consistent, isolated environment with Gateway pre-configured. No need to install Python or `uv` on your host for day-to-day Docker development.

#### Prerequisites

- Docker Desktop or Docker Engine

#### Setup Steps

1. **Configure the application**:
   ```bash
   # Copy example configuration
   cp config.example.yaml config.yaml

   # Set your API keys
   export OPENAI_API_KEY="your-key-here"
   # or edit config.yaml directly
   ```

2. **Initialize Docker environment** (first time only):
   ```bash
   make docker-init
   ```
   This will:
   - Pull the sandbox image when container sandbox mode is configured
   - Verify Docker is reachable

3. **Start development services**:
   ```bash
   make docker-start
   ```
   `make docker-start` reads `config.yaml` and starts `provisioner` only for provisioner/Kubernetes sandbox mode.

   Gateway starts with hot-reload in the dev compose stack.

4. **Access Gateway**:
   - Health: http://localhost:8001/health
   - OpenAPI: http://localhost:8001/docs
   - LangGraph-compatible API: http://localhost:8001/api

#### Docker Commands

```bash
# Build the custom k3s image (with pre-cached sandbox image)
make docker-init
# Start Docker dev Gateway (http://localhost:8001)
make docker-start
# Stop Docker development services
make docker-stop
# View Docker development logs
make docker-logs
# View Docker dev gateway logs
make docker-logs-gateway
# Production stack logs (after make up)
make docker-logs-prod
```

If Docker builds are slow in your network, you can override the default package registry before running `make docker-init` or `make docker-start`:

```bash
export UV_INDEX_URL=https://pypi.org/simple
```

#### Recommended host resources

Use these as practical starting points for development and review environments:

| Scenario | Starting point | Recommended | Notes |
|---------|-----------|------------|-------|
| `make dev` on one machine | 4 vCPU, 8 GB RAM | 8 vCPU, 16 GB RAM | Best when DeerFlow uses hosted model APIs. |
| `make docker-start` review environment | 4 vCPU, 8 GB RAM | 8 vCPU, 16 GB RAM | Docker image builds and sandbox containers need extra headroom. |
| Shared Linux test server | 8 vCPU, 16 GB RAM | 16 vCPU, 32 GB RAM | Prefer this for heavier multi-agent runs or multiple reviewers. |

`2 vCPU / 4 GB` environments often fail to start reliably or become unresponsive under normal DeerFlow workloads.

#### Linux: Docker daemon permission denied

If `make docker-init`, `make docker-start`, or `make docker-stop` fails on Linux with an error like below, your current user likely does not have permission to access the Docker daemon socket:

```text
unable to get image 'deer-flow-gateway': permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock
```

Recommended fix: add your current user to the `docker` group so Docker commands work without `sudo`.

1. Confirm the `docker` group exists:
   ```bash
   getent group docker
   ```
2. Add your current user to the `docker` group:
   ```bash
   sudo usermod -aG docker $USER
   ```
3. Apply the new group membership. The most reliable option is to log out completely and then log back in. If you want to refresh the current shell session instead, run:
   ```bash
   newgrp docker
   ```
4. Verify Docker access:
   ```bash
   docker ps
   ```
5. Retry the DeerFlow command:
   ```bash
   make docker-stop
   make docker-start
   ```

If `docker ps` still reports a permission error after `usermod`, fully log out and log back in before retrying.

#### Docker Architecture

```
Host Machine
  ↓
Docker Compose (deer-flow-dev)
  ├→ gateway (port 8001) ← Gateway API + embedded agent runtime (hot-reload in dev)
  └→ provisioner (optional, port 8002) ← Started only in provisioner/K8s sandbox mode
```

**Benefits of Docker Development**:
- ✅ Consistent environment across different machines
- ✅ No need to install Python or `uv` locally for containerized dev
- ✅ Isolated dependencies and services
- ✅ Easy cleanup and reset
- ✅ Hot-reload for all services
- ✅ Production-like environment

### Option 2: Local Development

If you prefer to run services directly on your machine:

#### Prerequisites

Check that you have all required tools installed:

```bash
make check
```

Required tools:
- Python 3.12+
- [uv](https://docs.astral.sh/uv/) (Python package manager)

On Windows, use **Git Bash** for root-level `make dev` / `make docker-start` (bash scripts).

#### Setup Steps

1. **Configure the application** (same as Docker setup above)

2. **Install dependencies** (this also sets up pre-commit hooks):
   ```bash
   make install
   ```

3. **Run Gateway** (either path):
   ```bash
   cd backend && make dev
   # or from repo root (Git Bash / macOS / Linux):
   make dev
   ```

4. **Access Gateway**:
   - Health: http://localhost:8001/health
   - OpenAPI: http://localhost:8001/docs
   - LangGraph-compatible API: http://localhost:8001/api

Optional: put a reverse proxy in front of Gateway for TLS or path prefixes. Browser clients on a different origin should set `GATEWAY_CORS_ORIGINS`.

## Project Structure

```
deer-flow/
├── config.example.yaml      # Configuration template
├── extensions_config.example.json  # MCP and Skills configuration template
├── Makefile                 # Build and development commands
├── scripts/
│   └── docker.sh           # Docker management script
├── docker/
│   ├── docker-compose-dev.yaml  # Docker dev (Gateway + optional provisioner)
│   └── docker-compose.yaml      # Docker production stack
├── backend/                 # Backend application
│   ├── app/gateway/        # FastAPI Gateway (port 8001)
│   ├── packages/harness/   # deerflow agent runtime package
│   ├── docs/               # Backend documentation
│   └── Makefile            # Backend commands (make dev, make test)
└── skills/                 # Agent skills
    ├── public/             # Public skills
    └── custom/             # Custom skills
```

## Architecture

```
HTTP clients (CLI, SDK, external UI)
  ↓
Gateway API (port 8001) ← /api/* and LangGraph-compatible /api/langgraph/*
  └→ Embedded agent runtime (lead agent, tools, sandbox, memory)
```

## Development Workflow

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** with hot-reload enabled

3. **Format and lint your code** (CI will reject unformatted code):
   ```bash
   cd backend
   make format   # ruff check --fix + ruff format
   ```

4. **Test your changes** thoroughly

5. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat: description of your changes"
   ```

6. **Push and create a Pull Request**:
   ```bash
   git push origin feature/your-feature-name
   ```

## Testing

```bash
cd backend
make test
```

### PR Regression Checks

Every pull request triggers:

- **Backend unit tests** — [.github/workflows/backend-unit-tests.yml](.github/workflows/backend-unit-tests.yml)
- **Lint check** — [.github/workflows/lint-check.yml](.github/workflows/lint-check.yml) (backend `ruff` only)

## Code Style

- **Backend (Python)**: We use `ruff` for linting and formatting. Run `make format` before committing.
- CI enforces formatting — PRs with unformatted code will fail the lint check.

## Documentation

- [Configuration Guide](backend/docs/CONFIGURATION.md) - Setup and configuration
- [Architecture Overview](backend/CLAUDE.md) - Technical architecture
- [MCP Setup Guide](backend/docs/MCP_SERVER.md) - Model Context Protocol configuration

## Need Help?

- Check existing [Issues](https://github.com/bytedance/deer-flow/issues)
- Read the [Documentation](backend/docs/)
- Ask questions in [Discussions](https://github.com/bytedance/deer-flow/discussions)

## License

By contributing to DeerFlow, you agree that your contributions will be licensed under the [MIT License](./LICENSE).
