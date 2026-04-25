#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v git >/dev/null 2>&1; then
  echo "Missing required command: git"
  exit 1
fi

cd "$ROOT_DIR"

git config core.hooksPath .githooks

chmod +x .githooks/pre-commit
chmod +x scripts/review-staged.sh

echo "Configured Git hooks path: .githooks"
echo "Pre-commit hook installed. Commits will now run staged review checks and: bash scripts/dev-all.sh precommit"