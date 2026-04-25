#!/usr/bin/env bash

run_dev() {
  check_command pnpm
  check_env_vars SECRET_KEY_BASE DB_USER DB_PASSWORD DB_HOST DB_PORT DB_NAME DB_HOST_READ DB_PORT_READ POOL_SIZE POOL_SIZE_READ REDIS_URL REDIS_READ_URL

  trap cleanup INT TERM EXIT

  echo "Starting Elixir API + all Next.js apps..."
  echo "Tip: press Ctrl+C once to stop everything."

  start_service "ai_api" "apps/ai_api" mix phx.server
  start_service "web-client" "frontend" pnpm --filter web-client dev -p 3000
  start_service "admin-panel" "frontend" pnpm --filter admin-panel dev -p 3001
  start_service "system-control" "frontend" pnpm --filter system-control dev -p 3002

  wait
}

run_prod() {
  check_command pnpm
  check_env_vars SECRET_KEY_BASE DB_USER DB_PASSWORD DB_HOST DB_PORT DB_NAME DB_HOST_READ DB_PORT_READ POOL_SIZE POOL_SIZE_READ REDIS_URL REDIS_READ_URL PORT

  trap cleanup INT TERM EXIT

  echo "Starting Elixir API + all Next.js apps in production mode..."
  echo "Using: PORT=$PORT"
  echo "Tip: press Ctrl+C once to stop everything."

  start_service "ai_api" "apps/ai_api" env MIX_ENV=prod PHX_SERVER=true PORT=$PORT mix phx.server
  start_service "web-client" "frontend" pnpm --filter web-client start -p 3000
  start_service "admin-panel" "frontend" pnpm --filter admin-panel start -p 3001
  start_service "system-control" "frontend" pnpm --filter system-control start -p 3002

  wait
}

run_release_build() {
  check_command pnpm
  check_env_vars SECRET_KEY_BASE DB_USER DB_PASSWORD DB_HOST DB_PORT DB_NAME

  echo "Building Phoenix release (MIX_ENV=prod)..."
  (
    cd "$ROOT_DIR"
    MIX_ENV=prod mix release ai_api
  )

  echo "Building frontend apps..."
  (
    cd "$ROOT_DIR/frontend"
    pnpm --filter web-client build
    pnpm --filter admin-panel build
    pnpm --filter system-control build
  )

  echo "Done: release + frontend builds completed."
}

run_prod_release() {
  check_command pnpm
  check_env_vars SECRET_KEY_BASE DB_USER DB_PASSWORD DB_HOST DB_PORT DB_NAME DB_HOST_READ DB_PORT_READ POOL_SIZE POOL_SIZE_READ REDIS_URL REDIS_READ_URL PORT

  trap cleanup INT TERM EXIT

  local release_bin="$ROOT_DIR/_build/prod/rel/ai_api/bin/ai_api"

  if [ ! -x "$release_bin" ]; then
    echo "Release binary not found: $release_bin"
    echo "Run: bash scripts/dev-all.sh release-build"
    exit 1
  fi

  echo "Starting Phoenix release + all Next.js apps in production mode..."
  echo "Using: PORT=$PORT"
  echo "Tip: press Ctrl+C once to stop everything."

  start_service "ai_api_release" "." env PHX_SERVER=true PORT=$PORT "$release_bin" start
  start_service "web-client" "frontend" pnpm --filter web-client start -p 3000
  start_service "admin-panel" "frontend" pnpm --filter admin-panel start -p 3001
  start_service "system-control" "frontend" pnpm --filter system-control start -p 3002

  wait
}
