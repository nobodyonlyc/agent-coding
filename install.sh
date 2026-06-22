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

# 3. Ensure the harness CLI binary — downloaded from GitHub Releases when missing.
#    The binary is gitignored (prebuilt, not tracked), so a fresh clone fetches it here.
#    Overridable: HARNESS_REPO=<owner/name>  HARNESS_VERSION=<tag|latest>
HARNESS_REPO="${HARNESS_REPO:-nobodyonlyc/harness}"
HARNESS_VERSION="${HARNESS_VERSION:-latest}"

detect_platform() {
  local os arch
  os="$(uname -s | tr '[:upper:]' '[:lower:]')"
  arch="$(uname -m)"
  case "$os" in
    linux*)  os="linux" ;;
    darwin*) os="darwin" ;;
  esac
  case "$arch" in
    x86_64|amd64)  arch="x86_64" ;;
    arm64|aarch64) arch="aarch64" ;;
  esac
  printf '%s-%s' "$os" "$arch"
}

download_harness() {
  local platform asset url rc=0
  platform="$(detect_platform)"
  asset="harness-${platform}"
  if [ "$HARNESS_VERSION" = "latest" ]; then
    url="https://github.com/${HARNESS_REPO}/releases/latest/download/${asset}"
  else
    url="https://github.com/${HARNESS_REPO}/releases/download/${HARNESS_VERSION}/${asset}"
  fi
  echo "    Downloading ${asset} (${HARNESS_VERSION}) from GitHub Releases ..."
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$ROOT_DIR/harness" || rc=$?
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$ROOT_DIR/harness" "$url" || rc=$?
  else
    echo "    ERROR: need curl or wget to download the harness binary." >&2
    return 1
  fi
  if [ "$rc" -ne 0 ] || [ ! -s "$ROOT_DIR/harness" ]; then
    rm -f "$ROOT_DIR/harness"
    echo "    ERROR: could not download ${asset} (${HARNESS_VERSION})." >&2
    echo "    URL: $url" >&2
    echo "    Releases: https://github.com/${HARNESS_REPO}/releases — or pin: HARNESS_VERSION=<tag> ./install.sh" >&2
    return 1
  fi
  chmod +x "$ROOT_DIR/harness"
  if [ "$(uname -s)" = "Darwin" ]; then
    xattr -d com.apple.quarantine "$ROOT_DIR/harness" 2>/dev/null || true
    command -v codesign >/dev/null 2>&1 && codesign --force --sign - "$ROOT_DIR/harness" >/dev/null 2>&1 || true
  fi
  return 0
}

echo "==> Checking harness CLI ..."
if [ -x "$ROOT_DIR/harness" ]; then
  echo "    harness binary present: $("$ROOT_DIR/harness" --version 2>/dev/null || echo ok)"
elif [ -f "$ROOT_DIR/harness" ]; then
  chmod +x "$ROOT_DIR/harness"
  echo "    harness binary present — set executable bit."
else
  echo "    harness binary not found — fetching from GitHub Releases (${HARNESS_REPO}) ..."
  if download_harness; then
    echo "    Installed harness: $("$ROOT_DIR/harness" --version 2>/dev/null || echo ok)"
  else
    echo "    WARN: automatic download failed — provide the prebuilt CLI manually to use backlog commands." >&2
  fi
fi

# 4. Build the harness SQLite DB from features.json if not yet present.
#    Safe: `init --bare` never overwrites an existing features.json — it imports it into a fresh DB.
if [ -x "$ROOT_DIR/harness" ] && [ ! -f "$ROOT_DIR/.harness/harness.db" ]; then
  echo "==> Building harness database (init --bare) ..."
  ( cd "$ROOT_DIR" && ./harness init --bare ) || echo "    WARN: 'harness init --bare' failed; run it manually." >&2
fi

echo ""
echo "==> Install complete."
if [ -x "$ROOT_DIR/harness" ]; then
  echo "    Next: ./init.sh        (sync app deps + baseline verification)"
  echo "          ./harness status (view backlog)"
else
  echo "    Next: install the harness binary, then ./init.sh"
fi
