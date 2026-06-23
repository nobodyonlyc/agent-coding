#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Resolve where the app lives. Bootstrapped projects scaffold into a named subfolder recorded as
# `source_dir:` in the Stack block (docs/design/architecture.md); fall back to legacy source/, then root.
resolve_app_dir() {
  local arch="$ROOT_DIR/docs/design/architecture.md" dir=""
  if [ -f "$arch" ]; then
    dir="$(grep -m1 -iE '^[-*[:space:]]*source_dir:' "$arch" | sed -E 's/.*source_dir:[[:space:]]*//; s|[[:space:]]*(#.*)?$||; s|/*$||')"
  fi
  if [ -n "$dir" ] && [ -d "$ROOT_DIR/$dir" ]; then echo "$ROOT_DIR/$dir"; return; fi
  if [ -d "$ROOT_DIR/source" ]; then echo "$ROOT_DIR/source"; return; fi
  echo "$ROOT_DIR"
}
APP_DIR="$(resolve_app_dir)"
cd "$APP_DIR"

echo "==> Working directory: $PWD"

echo "==> Syncing dependencies..."
if [ -f "Cargo.toml" ]; then
  cargo check
elif [ -f "package.json" ]; then
  npm install
elif [ -f "requirements.txt" ]; then
  pip install -r requirements.txt
elif [ -f "pyproject.toml" ]; then
  pip install .
elif [ -f "go.mod" ]; then
  go mod download
else
  echo "No standard dependency file found. Skipping dependency sync."
fi

echo "==> Running baseline verification..."
if [ -f "Cargo.toml" ]; then
  cargo test
elif [ -f "package.json" ]; then
  npm test
elif [ -f "go.mod" ]; then
  go test ./...
fi

"$ROOT_DIR/harness" status
