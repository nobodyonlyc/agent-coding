#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# App lives in the subfolder recorded as `source_dir:` in the Stack block
# (docs/design/architecture.md); fall back to legacy source/, then the repo root.
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

echo "==> Running app from: $APP_DIR"
if [ -f "docker-compose.yml" ] || [ -f "compose.yml" ]; then
  exec docker compose up
elif [ -f "package.json" ]; then
  if grep -q '"dev"' package.json; then exec npm run dev; else exec npm start; fi
elif [ -f "manage.py" ]; then
  exec python manage.py runserver
elif [ -f "Cargo.toml" ]; then
  exec cargo run
elif [ -f "go.mod" ]; then
  exec go run ./...
else
  echo "run.sh: could not auto-detect a run command for this stack." >&2
  echo "Edit run.sh and set the real command (e.g. pnpm dev / uvicorn app:app --reload)." >&2
  exit 1
fi
