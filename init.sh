#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

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

./harness status
