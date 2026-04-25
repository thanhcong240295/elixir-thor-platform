#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-dev}"
if [ $# -gt 0 ]; then
  shift
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/dev-all/common.sh"
source "$SCRIPT_DIR/dev-all/tasks/core.sh"
source "$SCRIPT_DIR/dev-all/tasks/runtime.sh"
source "$SCRIPT_DIR/dev-all/tasks/sonar.sh"

check_command mix

case "$MODE" in
  dev)
    run_dev
    ;;
  prod)
    run_prod
    ;;
  release-build)
    run_release_build
    ;;
  prod-release)
    run_prod_release
    ;;
  setup)
    run_setup
    ;;
  reset-db)
    run_reset_db
    ;;
  infra-up)
    run_infra_up
    ;;
  infra-down)
    run_infra_down
    ;;
  get)
    run_get
    ;;
  build)
    run_build
    ;;
  clean)
    run_clean
    ;;
  check)
    run_check
    ;;
  format)
    run_format
    ;;
  test)
    run_test "$@"
    ;;
  precommit)
    run_precommit
    ;;
  sonar)
    run_sonar
    ;;
  *)
    echo "Unknown command: $MODE"
    echo "Usage: bash scripts/dev-all.sh [dev|prod|release-build|prod-release|setup|reset-db|infra-up|infra-down|get|build|clean|check|format|test|precommit|sonar] [mix test args...]"
    exit 1
    ;;
esac
