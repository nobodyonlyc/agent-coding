#!/usr/bin/env bash
# One-shot installer for agent-coding.
# Fetches the harness-skills submodule (and its nested caveman vendor), then
# wires skills / workflows / hooks into each detected agent (Claude Code,
# Antigravity, Codex). Idempotent and re-runnable.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

SKILLS_SRC="$ROOT_DIR/.harness/skills-src"

echo "==> agent-coding install"
echo "    project: $ROOT_DIR"

# 1. Submodules: harness-skills (.harness/skills-src) + nested vendor/caveman.
#    --init brings up new submodules; --recursive descends into caveman.
#    No --remote: each gitlink is pinned to the commit recorded in the index,
#    so we install exactly what the repo declares (reproducible installs).
echo "==> Syncing git submodules (harness-skills + vendor/caveman) ..."
if [ -d "$ROOT_DIR/.git" ] || git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git submodule sync --recursive >/dev/null 2>&1 || true
  git submodule update --init --recursive
else
  echo "    WARN: not a git checkout — cannot fetch submodules."
fi

if [ ! -f "$SKILLS_SRC/install.sh" ]; then
  echo "    ERROR: $SKILLS_SRC/install.sh missing — submodule did not populate." >&2
  echo "    Try: git submodule update --init --recursive" >&2
  exit 1
fi

# 2. Wire skills, workflows, and hooks for every detected agent.
echo "==> Wiring agent projections (skills / workflows / hooks) ..."
bash "$SKILLS_SRC/install.sh"

# 3. Sanity-check the harness CLI binary (prebuilt, not tracked in git).
echo "==> Checking harness CLI ..."
if [ -x "$ROOT_DIR/harness" ]; then
  echo "    harness binary present and executable."
elif [ -f "$ROOT_DIR/harness" ]; then
  chmod +x "$ROOT_DIR/harness"
  echo "    harness binary present — set executable bit."
else
  echo "    WARN: ./harness binary not found. Provide the prebuilt CLI to use the backlog commands."
fi

echo ""
echo "==> Install complete."
echo "    Next: ./init.sh   (sync app deps + baseline verification)"
echo "          ./harness status"
