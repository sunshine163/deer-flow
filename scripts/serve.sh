#!/usr/bin/env bash
#
# serve.sh — DeerFlow Gateway launcher (backend only)
#
# Usage:
#   ./scripts/serve.sh [--dev|--prod] [--daemon] [--stop|--restart]
#
# Modes:
#   --dev       Development mode with hot-reload (default)
#   --prod      Production mode, no hot-reload
#   --daemon    Run Gateway in background (nohup), exit after startup
#
# Actions:
#   --skip-install  Skip dependency installation (faster restart)
#   --stop      Stop the Gateway and exit
#   --restart   Stop the Gateway, then start with the given mode flags
#
# Examples:
#   ./scripts/serve.sh --dev                 # Gateway dev, hot reload
#   ./scripts/serve.sh --prod                # Gateway prod
#   ./scripts/serve.sh --dev --daemon        # Gateway dev, background
#   ./scripts/serve.sh --stop                # Stop Gateway
#   ./scripts/serve.sh --restart --dev       # Restart dev Gateway
#
# Must be run from the repo root directory.

set -e

REPO_ROOT="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd -P)"
cd "$REPO_ROOT"

# ── Load .env ────────────────────────────────────────────────────────────────

if [ -f "$REPO_ROOT/.env" ]; then
    set -a
    source "$REPO_ROOT/.env"
    set +a
fi

# ── Argument parsing ─────────────────────────────────────────────────────────

DEV_MODE=true
DAEMON_MODE=false
SKIP_INSTALL=false
ACTION="start"   # start | stop | restart

for arg in "$@"; do
    case "$arg" in
        --dev)     DEV_MODE=true ;;
        --prod)    DEV_MODE=false ;;
        --daemon)  DAEMON_MODE=true ;;
        --skip-install) SKIP_INSTALL=true ;;
        --stop)    ACTION="stop" ;;
        --restart) ACTION="restart" ;;
        *)
            echo "Unknown argument: $arg"
            echo "Usage: $0 [--dev|--prod] [--daemon] [--skip-install] [--stop|--restart]"
            exit 1
            ;;
    esac
done

# ── Stop helper ──────────────────────────────────────────────────────────────

_kill_port() {
    local port=$1
    local pid
    pid=$(lsof -ti :"$port" 2>/dev/null) || true
    if [ -n "$pid" ]; then
        kill -9 $pid 2>/dev/null || true
    fi
}

stop_all() {
    echo "Stopping Gateway..."
    pkill -f "uvicorn app.gateway.app:app" 2>/dev/null || true
    _kill_port 8001
    ./scripts/cleanup-containers.sh deer-flow-sandbox 2>/dev/null || true
    echo "✓ Gateway stopped"
}

# ── Action routing ───────────────────────────────────────────────────────────

if [ "$ACTION" = "stop" ]; then
    stop_all
    exit 0
fi

ALREADY_STOPPED=false
if [ "$ACTION" = "restart" ]; then
    stop_all
    sleep 1
    ALREADY_STOPPED=true
fi

# Mode label for banner
if $DEV_MODE; then
    MODE_LABEL="DEV (Gateway, hot-reload enabled)"
else
    MODE_LABEL="PROD (Gateway, optimized)"
fi

if $DAEMON_MODE; then
    MODE_LABEL="$MODE_LABEL [daemon]"
fi

# Extra flags for uvicorn
if $DEV_MODE && ! $DAEMON_MODE; then
    GATEWAY_EXTRA_FLAGS="--reload --reload-include='*.yaml' --reload-include='.env' --reload-exclude='*.pyc' --reload-exclude='__pycache__' --reload-exclude='sandbox/' --reload-exclude='.deer-flow/'"
else
    GATEWAY_EXTRA_FLAGS=""
fi

# ── Stop existing Gateway (skip if restart already did it) ───────────────────

if ! $ALREADY_STOPPED; then
    stop_all
    sleep 1
fi

# ── Config check ─────────────────────────────────────────────────────────────

if ! { \
        [ -n "$DEER_FLOW_CONFIG_PATH" ] && [ -f "$DEER_FLOW_CONFIG_PATH" ] || \
        [ -f backend/config.yaml ] || \
        [ -f config.yaml ]; \
    }; then
    echo "✗ No DeerFlow config file found."
    echo "  Run 'make setup' (recommended) or 'make config' to generate config.yaml."
    exit 1
fi

"$REPO_ROOT/scripts/config-upgrade.sh"

# ── Install dependencies ────────────────────────────────────────────────────

# Pick a Python for the extras detector. Falls back to plain `python` for
# Windows/Git Bash where only `python` is on PATH.
if command -v python3 >/dev/null 2>&1; then
    DETECT_PYTHON="python3"
elif command -v python >/dev/null 2>&1; then
    DETECT_PYTHON="python"
else
    DETECT_PYTHON=""
fi

# Resolve uv extras (postgres, etc.) from UV_EXTRAS or config.yaml so that
# `uv sync` does not wipe out optional dependencies on every restart. See
# scripts/detect_uv_extras.py and Issue #2754 for context. The detector
# whitelists extra names against `^[A-Za-z][A-Za-z0-9_-]*$`, so the unquoted
# splat below only sees valid uv argument tokens.
#
# Stderr is intentionally NOT redirected so the user sees:
#   - whitelist warnings (e.g. "ignoring invalid UV_EXTRAS entry ';'");
#   - detector crashes (e.g. unexpected Python error).
# `|| true` keeps `set -e` from killing dev startup on a detector failure;
# the result is just an empty UV_EXTRAS_FLAGS, which means "no extras".
UV_EXTRAS_FLAGS=""
if [ -n "$DETECT_PYTHON" ]; then
    UV_EXTRAS_FLAGS=$("$DETECT_PYTHON" "$REPO_ROOT/scripts/detect_uv_extras.py" || { echo "[serve.sh] detect_uv_extras.py failed (exit $?) — proceeding without extras" >&2; echo ""; })
fi

if ! $SKIP_INSTALL; then
    echo "Syncing backend dependencies..."
    if [ -n "$UV_EXTRAS_FLAGS" ]; then
        echo "  • uv extras: $UV_EXTRAS_FLAGS"
    fi
    # `--all-packages` propagates extras into workspace members (deerflow-harness
    # in particular). Required for postgres extras — see PR #2584.
    # Intentionally unquoted to splat multiple `--extra X` pairs.
    (cd backend && uv sync --quiet --all-packages $UV_EXTRAS_FLAGS) || { echo "✗ Backend dependency install failed"; exit 1; }
    echo "✓ Dependencies synced"
else
    echo "⏩ Skipping dependency install (--skip-install)"
fi

# ── Banner ───────────────────────────────────────────────────────────────────

echo ""
echo "=========================================="
echo "  Starting DeerFlow Gateway"
echo "=========================================="
echo ""
echo "  Mode: $MODE_LABEL"
echo ""
echo "  Service:"
echo "    Gateway     → http://localhost:8001  (REST API + agent runtime)"
echo ""

# ── Cleanup handler ──────────────────────────────────────────────────────────

cleanup() {
    trap - INT TERM
    echo ""
    stop_all
    exit 0
}

trap cleanup INT TERM

# ── Helper: start a service ──────────────────────────────────────────────────

# run_service NAME COMMAND PORT TIMEOUT
# In daemon mode, wraps with nohup. Waits for port to be ready.
run_service() {
    local name="$1" cmd="$2" port="$3" timeout="$4"

    echo "Starting $name..."
    if $DAEMON_MODE; then
        nohup sh -c "$cmd" > /dev/null 2>&1 &
    else
        sh -c "$cmd" &
    fi

    ./scripts/wait-for-port.sh "$port" "$timeout" "$name" || {
        local logfile="logs/$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-').log"
        echo "✗ $name failed to start."
        [ -f "$logfile" ] && tail -20 "$logfile"
        cleanup
    }
    echo "✓ $name started on localhost:$port"
}

# ── Start Gateway ────────────────────────────────────────────────────────────

mkdir -p logs

# Windows cold start (uvicorn --reload + heavy imports) often needs >30s
GATEWAY_START_TIMEOUT=30
case "$(uname -s 2>/dev/null)" in
    MINGW*|MSYS*|CYGWIN*) GATEWAY_START_TIMEOUT=60 ;;
esac

run_service "Gateway" \
    "cd backend && PYTHONPATH=. uv run uvicorn app.gateway.app:app --host 0.0.0.0 --port 8001 $GATEWAY_EXTRA_FLAGS > ../logs/gateway.log 2>&1" \
    8001 "$GATEWAY_START_TIMEOUT"

# ── Ready ────────────────────────────────────────────────────────────────────

echo ""
echo "=========================================="
echo "  ✓ DeerFlow Gateway is running!  [$MODE_LABEL]"
echo "=========================================="
echo ""
echo "  🌐 http://localhost:8001"
echo ""
echo "  Health:  GET /health"
echo "  API:     /api/langgraph/*  →  agent runtime"
echo "           /api/*              →  REST API"
echo ""
echo "  📋 Logs: logs/gateway.log"
echo ""

if $DAEMON_MODE; then
    echo "  🛑 Stop: make stop"
    trap - INT TERM
else
    echo "  Press Ctrl+C to stop the Gateway"
    wait
fi
