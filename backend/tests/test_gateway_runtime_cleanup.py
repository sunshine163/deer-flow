"""Regression coverage for the Gateway-owned LangGraph API runtime."""

from __future__ import annotations

import re
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]


def _read(path: str) -> str:
    return (REPO_ROOT / path).read_text(encoding="utf-8")


def test_root_makefile_no_longer_exposes_transition_gateway_targets():
    makefile = _read("Makefile")

    assert "dev-pro" not in makefile
    assert "start-pro" not in makefile
    assert "dev-daemon-pro" not in makefile
    assert "start-daemon-pro" not in makefile
    assert "docker-start-pro" not in makefile
    assert "up-pro" not in makefile
    assert not re.search(r"serve\.sh .*--gateway", makefile)
    assert "docker.sh start --gateway" not in makefile
    assert "deploy.sh --gateway" not in makefile


def test_service_launchers_always_use_gateway_runtime():
    operational_files = {
        "scripts/serve.sh": _read("scripts/serve.sh"),
        "scripts/docker.sh": _read("scripts/docker.sh"),
        "scripts/deploy.sh": _read("scripts/deploy.sh"),
        "docker/docker-compose-dev.yaml": _read("docker/docker-compose-dev.yaml"),
        "docker/docker-compose.yaml": _read("docker/docker-compose.yaml"),
    }

    for path, content in operational_files.items():
        assert "start --gateway" not in content, path
        assert "deploy.sh --gateway" not in content, path
        assert "langgraph dev" not in content, path
        assert "LANGGRAPH_UPSTREAM" not in content, path
        assert "LANGGRAPH_REWRITE" not in content, path


def test_docker_compose_is_gateway_only_without_nginx_or_frontend():
    for path in ("docker/docker-compose-dev.yaml", "docker/docker-compose.yaml"):
        content = _read(path)

        assert "nginx:" not in content, path
        assert "frontend:" not in content, path
        assert "container_name: deer-flow-nginx" not in content, path
        assert "container_name: deer-flow-frontend" not in content, path
        assert "8001:8001" in content or "${GATEWAY_PORT:-8001}:8001" in content, path


def test_gateway_cors_configuration_uses_gateway_allowlist():
    gateway_config = _read("backend/app/gateway/config.py")
    gateway_app = _read("backend/app/gateway/app.py")
    csrf_middleware = _read("backend/app/gateway/csrf_middleware.py")

    assert not re.search(r"(?<!GATEWAY_)[\"']CORS_ORIGINS[\"']", gateway_config)
    assert "cors_origins" not in gateway_config
    assert "get_configured_cors_origins" in gateway_app
    assert "GATEWAY_CORS_ORIGINS" in csrf_middleware


def test_frontend_directory_removed_from_repo():
    """This fork ships Gateway-only; do not reintroduce a bundled frontend tree."""
    frontend_root = REPO_ROOT / "frontend"
    assert not frontend_root.exists(), "frontend/ should not exist in this backend-only fork; use an external client against http://localhost:8001"
