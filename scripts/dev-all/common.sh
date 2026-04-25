#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Load .env file if it exists.
if [ -f "$ROOT_DIR/.env" ]; then
  set -a
  source "$ROOT_DIR/.env"
  set +a
else
  echo "ERROR: .env file not found at $ROOT_DIR/.env"
  echo "Please create .env from .env.example: cp .env.example .env"
  exit 1
fi

check_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1"
    exit 1
  fi
}

check_env_vars() {
  local -a required_vars=("$@")
  local missing=()

  for var in "${required_vars[@]}"; do
    if [ -z "${!var:-}" ]; then
      missing+=("$var")
    fi
  done

  if [ ${#missing[@]} -gt 0 ]; then
    echo "ERROR: Missing required environment variables:"
    printf '  - %s\n' "${missing[@]}"
    echo ""
    echo "Please set these in .env file at $ROOT_DIR/.env"
    exit 1
  fi
}

PIDS=()

start_service() {
  local name="$1"
  local dir="$2"
  shift 2

  (
    cd "$ROOT_DIR/$dir"
    echo "[$name] starting in $dir"
    "$@"
  ) &

  PIDS+=("$!")
}

cleanup() {
  echo
  echo "Stopping all services..."
  for pid in "${PIDS[@]}"; do
    kill "$pid" >/dev/null 2>&1 || true
  done
}
