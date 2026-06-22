#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# App lives under source/ for bootstrapped projects, else at the repo root.
if [ -d "$ROOT_DIR/source" ]; then APP_DIR="$ROOT_DIR/source"; else APP_DIR="$ROOT_DIR"; fi
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
