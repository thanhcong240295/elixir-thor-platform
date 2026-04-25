#!/usr/bin/env bash

run_sonar() {
  echo "Running SonarQube scan..."

  if ! command -v sonar-scanner >/dev/null 2>&1; then
    echo "ERROR: sonar-scanner not found."
    echo "Install it: https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner/"
    echo "Or via brew: brew install sonar-scanner"
    exit 1
  fi

  SONAR_HOST="${SONAR_HOST:-http://localhost:9000}"
  SONAR_TOKEN="${SONAR_TOKEN:-admin}"

  echo "Scanning against: $SONAR_HOST"

  (
    cd "$ROOT_DIR"
    sonar-scanner \
      -Dsonar.host.url="$SONAR_HOST" \
      -Dsonar.token="$SONAR_TOKEN"
  )

  echo "Done: SonarQube scan complete."
  echo "View results at: $SONAR_HOST/dashboard?id=elixir_thor_platform"
}
