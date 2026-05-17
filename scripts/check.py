#!/usr/bin/env python3
"""Cross-platform backend dependency checker for DeerFlow."""

from __future__ import annotations

import shutil
import subprocess
import sys


def configure_stdio() -> None:
    """Prefer UTF-8 output so Unicode status markers render on Windows."""
    for stream_name in ("stdout", "stderr"):
        stream = getattr(sys, stream_name, None)
        if hasattr(stream, "reconfigure"):
            try:
                stream.reconfigure(encoding="utf-8", errors="replace")
            except (OSError, ValueError):
                continue


def run_command(command: list[str]) -> str | None:
    """Run a command and return trimmed stdout, or None on failure."""
    try:
        result = subprocess.run(command, capture_output=True, text=True, check=True, shell=False)
    except (OSError, subprocess.CalledProcessError):
        return None
    return result.stdout.strip() or result.stderr.strip()


def main() -> int:
    configure_stdio()
    print("==========================================")
    print("  Checking Backend Dependencies")
    print("==========================================")
    print()

    print("Checking uv...")
    if shutil.which("uv"):
        uv_version_text = run_command(["uv", "--version"])
        if uv_version_text:
            uv_version_parts = uv_version_text.split()
            uv_version = uv_version_parts[1] if len(uv_version_parts) > 1 else uv_version_text
            print(f"  OK uv {uv_version}")
        else:
            print("  INFO Unable to determine uv version")
            print("    Visit: https://docs.astral.sh/uv/getting-started/installation/")
            return 1
    else:
        print("  FAIL uv not found")
        print("    Visit: https://docs.astral.sh/uv/getting-started/installation/")
        return 1

    print()
    print("==========================================")
    print("  OK Backend dependencies are ready")
    print("==========================================")
    print()
    print("You can now run:")
    print("  make install            - Install backend deps (uv sync + pre-commit)")
    print("  cd backend && make dev  - Gateway with hot-reload → http://localhost:8001")
    print("  make dev                - Gateway via serve.sh (same port, repo-root workflow)")
    print("  make setup              - Interactive config wizard (recommended)")
    print("  make config             - Copy config template (manual setup)")
    print("  make doctor             - Verify config and runtime health")
    return 0


if __name__ == "__main__":
    sys.exit(main())
