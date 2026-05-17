# DeerFlow Install (Gateway / Backend Only)

This file is for coding agents. If the DeerFlow repository is not already cloned and open, clone the user's fork or `https://github.com/bytedance/deer-flow.git`, then continue from the repository root.

This fork runs **Gateway API + embedded agent runtime** on port **8001**. It does not install or start a bundled `frontend/`, Node.js, pnpm, or nginx.

## Goal

Bootstrap a DeerFlow backend development workspace with the least risky path available.

Default preference:

1. Docker development environment (`make docker-init` → `make docker-start`)
2. Local development environment (`make check` → `make install` → `cd backend && make dev`)

Do not assume API keys or model credentials exist. Set up everything that can be prepared safely, then stop with a concise summary of what the user still needs to provide.

## Operating Rules

- Be idempotent. Re-running this document should not damage an existing setup.
- Prefer existing repo commands over ad hoc shell commands.
- Do not use `sudo` or install system packages without explicit user approval.
- Do not overwrite existing user config values unless the user asks.
- If a step fails, stop, explain the blocker, and provide the smallest next action.
- If multiple setup paths are possible, prefer Docker when Docker is already available.
- On Windows, run bash-based targets (`make dev`, `make docker-start`) from **Git Bash** when possible.

## Success Criteria

Consider the setup successful when all of the following are true:

- The DeerFlow repository is cloned and the current working directory is the repo root.
- `config.yaml` exists.
- For Docker setup, `make docker-init` completed successfully and Docker prerequisites are prepared, but services are not assumed to be running yet.
- For local setup, `make check` passed and `make install` completed successfully.
- The user receives the exact next command to launch Gateway.
- The user also receives any missing model configuration or referenced environment variable names from `config.yaml`, without inspecting secret-bearing files for actual values.

## Steps

- If the current directory is not the DeerFlow repository root, clone the repository if needed, then change into the repository root.
- Confirm the repository root by checking that `Makefile`, `backend/`, and `config.example.yaml` exist.
- Detect whether `config.yaml` already exists.
- If `config.yaml` does not exist, run `make config` or `make setup` (interactive wizard; requires a TTY).
- Detect whether Docker is available and the daemon is reachable with `docker info`.
- If Docker is available:
  - Run `make docker-init`.
  - Treat this as Docker prerequisite preparation only. Do not claim that app services, compose validation, or image builds have already succeeded.
  - Do not start long-running services unless the user explicitly asks or this setup request clearly includes launch verification.
  - Tell the user the recommended next command is `make docker-start` (Gateway at `http://localhost:8001`).
- If Docker is not available:
  - Run `make check`.
  - If `make check` reports missing tools (typically `uv`), stop and report the missing tools instead of attempting privileged installs.
  - If prerequisites are satisfied, run `make install`.
  - Tell the user the recommended next command is `cd backend && make dev` (or `make dev` from the repo root on Git Bash / macOS / Linux).
- Inspect `config.yaml` only for missing model entries or referenced environment variable placeholders. Do not read `.env` or other secret-bearing files.
- If no model is configured, tell the user they must add at least one entry under `models` in `config.yaml`, or run `make setup`.
- If `config.yaml` references variables such as `$OPENAI_API_KEY`, tell the user which variable names still need real values, but do not verify them by opening secret-bearing files.
- If the repository already appears configured, avoid repeating expensive work unless it is necessary to verify the environment.

## Verification

Use the lightest verification that matches the chosen setup path.

For Docker setup:

- Confirm `make docker-init` completed successfully.
- Confirm `config.yaml` exists.
- State explicitly that Docker services were not started and `make docker-start` is still the first real launch step.
- Do not leave background services running unless the user asked for that.

For local setup:

- Confirm `make install` completed successfully.
- Confirm `config.yaml` exists.
- Do not leave background services running unless the user asked for that.

## Final Response Format

Return a short status report with:

1. Setup path used: Docker or local
2. Setup level reached: Docker prerequisites prepared or backend dependencies installed
3. Files created or detected: for example `config.yaml`
4. Remaining user action: model config, env var values, auth files, or nothing
5. Exact next command to start Gateway (include URL `http://localhost:8001` and `GET /health`)

## EXECUTE NOW

Complete the steps above. When finished, stop after the setup boundary and report status instead of continuing into unrelated project work.
