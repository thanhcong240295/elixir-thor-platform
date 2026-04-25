#!/usr/bin/env bash

run_get() {
  check_command pnpm

  echo "Installing backend deps..."
  (
    cd "$ROOT_DIR"
    mix deps.get
  )

  echo "Installing frontend deps..."
  (
    cd "$ROOT_DIR/frontend"
    pnpm install
  )

  echo "Done: dependencies installed."
}

run_setup() {
  run_get

  echo "Setting up database (create + migrate)..."
  (
    cd "$ROOT_DIR/apps/ai_api"
    mix ecto.setup
  )

  echo "Done: database setup completed."
}

run_reset_db() {
  check_env_vars SECRET_KEY_BASE DB_USER DB_PASSWORD DB_HOST DB_PORT DB_NAME

  echo "Resetting database (drop + create + migrate + seed)..."
  (
    cd "$ROOT_DIR/apps/ai_api"
    mix ecto.reset
  )

  echo "Done: database reset completed."
}

run_infra_up() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "Missing required command: docker"
    exit 1
  fi

  echo "Starting Postgres + Redis (docker compose)..."
  (
    cd "$ROOT_DIR"
    docker compose up -d
  )

  echo "Done: infrastructure is up."
}

run_infra_down() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "Missing required command: docker"
    exit 1
  fi

  echo "Stopping Postgres + Redis (docker compose)..."
  (
    cd "$ROOT_DIR"
    docker compose down
  )

  echo "Done: infrastructure is down."
}

run_build() {
  check_command pnpm

  echo "Building backend..."
  (
    cd "$ROOT_DIR"
    mix compile
  )

  echo "Building frontend apps..."
  (
    cd "$ROOT_DIR/frontend"
    pnpm --filter web-client build
    pnpm --filter admin-panel build
    pnpm --filter system-control build
  )

  echo "Done: all builds completed."
}

run_clean() {
  echo "Cleaning backend build artifacts..."
  (
    cd "$ROOT_DIR"
    mix clean
  )

  echo "Cleaning frontend build artifacts..."
  rm -rf \
    "$ROOT_DIR/frontend/web-client/.next" \
    "$ROOT_DIR/frontend/admin-panel/.next" \
    "$ROOT_DIR/frontend/system-control/.next"

  echo "Done: build artifacts removed."
}

run_check() {
  echo "Checking code format and compilation..."
  (
    cd "$ROOT_DIR"
    mix format --check-formatted
  )

  echo "Checking for compilation warnings..."
  (
    cd "$ROOT_DIR"
    mix compile --warnings-as-errors
  )

  echo "Checking for unused dependencies..."
  (
    cd "$ROOT_DIR"
    mix deps.unlock --unused --check
  )

  echo "Done: all code checks passed."
}

run_format() {
  echo "Formatting Elixir code..."
  (
    cd "$ROOT_DIR"
    mix format
  )

  echo "Done: code formatted."
}

run_test() {
  check_env_vars SECRET_KEY_BASE DB_USER DB_PASSWORD DB_HOST DB_PORT DB_NAME_TEST POOL_SIZE DB_HOST_READ DB_PORT_READ POOL_SIZE_READ REDIS_URL_TEST REDIS_READ_URL_TEST

  echo "Running backend tests..."
  (
    cd "$ROOT_DIR/apps/ai_api"
    MIX_ENV=test mix test "$@"
  )

  echo "Done: tests completed."
}

run_precommit() {
  check_env_vars SECRET_KEY_BASE DB_USER DB_PASSWORD DB_HOST DB_PORT DB_NAME

  echo "Running precommit checks..."
  echo "  - Compiling with warnings-as-errors..."
  echo "  - Checking unused dependencies..."
  echo "  - Formatting code..."
  echo "  - Running tests..."
  echo ""

  (
    cd "$ROOT_DIR"
    mix precommit
  )

  echo "Done: all precommit checks passed."
}
