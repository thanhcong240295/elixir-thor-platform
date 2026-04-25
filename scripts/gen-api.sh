#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="$ROOT_DIR/apps/ai_api"

usage() {
  cat <<'EOF'
Usage: bash scripts/gen-api.sh <namespace-path> <resource-name> <action> <http-method>

Examples:
  bash scripts/gen-api.sh gateway/admin report create post
  bash scripts/gen-api.sh gateway/system audit_log index get

Arguments:
  namespace-path  Folder/module path shared by web and domain modules, e.g. gateway/admin
  resource-name   Snake_case resource base name, e.g. report or audit_log
  action          Controller action/function name, e.g. create, index, show
  http-method     HTTP verb: get, post, put, patch, delete

This script generates:
  - AiApiWeb controller stub with OpenApiSpex operation metadata
  - AiApiWeb.ApiSchemas module with request/data schema functions
  - AiApi domain service module stub

It does not modify router.ex or api_spec.ex automatically.
EOF
}

camelize_segment() {
  local value="$1"
  local result=""
  local part

  IFS='_' read -r -a parts <<< "$value"
  for part in "${parts[@]}"; do
    result+="${part^}"
  done

  printf '%s' "$result"
}

camelize_path() {
  local value="$1"
  local result=""
  local segment

  IFS='/' read -r -a segments <<< "$value"
  for segment in "${segments[@]}"; do
    [ -z "$segment" ] && continue
    result+=".$(camelize_segment "$segment")"
  done

  printf '%s' "${result#.}"
}

http_method_upper() {
  printf '%s' "$1" | tr '[:lower:]' '[:upper:]'
}

if [ $# -ne 4 ]; then
  usage
  exit 1
fi

NAMESPACE_PATH="${1#/}"
NAMESPACE_PATH="${NAMESPACE_PATH%/}"
RESOURCE_NAME="$2"
ACTION_NAME="$3"
HTTP_METHOD="$(printf '%s' "$4" | tr '[:upper:]' '[:lower:]')"

case "$HTTP_METHOD" in
  get|post|put|patch|delete)
    ;;
  *)
    echo "Unsupported http-method: $HTTP_METHOD"
    usage
    exit 1
    ;;
esac

if [ -z "$NAMESPACE_PATH" ] || [ -z "$RESOURCE_NAME" ] || [ -z "$ACTION_NAME" ]; then
  usage
  exit 1
fi

WEB_NAMESPACE="$(camelize_path "$NAMESPACE_PATH")"
DOMAIN_NAMESPACE="$WEB_NAMESPACE"
RESOURCE_MODULE="$(camelize_segment "$RESOURCE_NAME")"
TAG_NAME="${NAMESPACE_PATH//\//-}"
METHOD_LABEL="$(http_method_upper "$HTTP_METHOD")"
RESOURCE_LABEL="${RESOURCE_NAME//_/ }"

CONTROLLER_MODULE="AiApiWeb.${WEB_NAMESPACE}.${RESOURCE_MODULE}Controller"
SCHEMA_MODULE="AiApiWeb.ApiSchemas.${WEB_NAMESPACE}.${RESOURCE_MODULE}"
SERVICE_MODULE="AiApi.${DOMAIN_NAMESPACE}.${RESOURCE_MODULE}"

CONTROLLER_DIR="$APP_DIR/lib/ai_api_web/controllers/$NAMESPACE_PATH"
SCHEMA_DIR="$APP_DIR/lib/ai_api_web/api_schemas/$NAMESPACE_PATH"
SERVICE_DIR="$APP_DIR/lib/ai_api/$NAMESPACE_PATH"

CONTROLLER_FILE="$CONTROLLER_DIR/${RESOURCE_NAME}_controller.ex"
SCHEMA_FILE="$SCHEMA_DIR/${RESOURCE_NAME}.ex"
SERVICE_FILE="$SERVICE_DIR/${RESOURCE_NAME}.ex"

for file_path in "$CONTROLLER_FILE" "$SCHEMA_FILE" "$SERVICE_FILE"; do
  if [ -e "$file_path" ]; then
    echo "Refusing to overwrite existing file: $file_path"
    exit 1
  fi
done

mkdir -p "$CONTROLLER_DIR" "$SCHEMA_DIR" "$SERVICE_DIR"

REQUEST_BODY_BLOCK=""
if [ "$HTTP_METHOD" = "post" ] || [ "$HTTP_METHOD" = "put" ] || [ "$HTTP_METHOD" = "patch" ]; then
  REQUEST_BODY_BLOCK=$(cat <<EOF
    request_body: {
      "${METHOD_LABEL} ${RESOURCE_LABEL} request",
      "application/json",
      ResourceSchema.request_schema(),
      required: true
    },
EOF
)
fi

cat > "$CONTROLLER_FILE" <<EOF
defmodule ${CONTROLLER_MODULE} do
  use AiApiWeb, :api_controller
  use OpenApiSpex.ControllerSpecs

  alias ${SERVICE_MODULE}
  alias AiApiWeb.ApiSchemas
  alias ${SCHEMA_MODULE}, as: ResourceSchema

  tags(["${TAG_NAME}"])

  operation(:${ACTION_NAME},
    operation_id: "${CONTROLLER_MODULE}.${ACTION_NAME}",
    summary: "${METHOD_LABEL} ${RESOURCE_LABEL}",
    description: "TODO: describe the ${ACTION_NAME} ${RESOURCE_LABEL} endpoint.",
${REQUEST_BODY_BLOCK}    responses: [
      ok: {
        "${METHOD_LABEL} ${RESOURCE_LABEL} response",
        "application/json",
        ApiSchemas.success_response_schema(ResourceSchema.data_schema())
      }
    ]
  )

  def ${ACTION_NAME}(conn, params) do
    json(conn, %{
      success: true,
      message: "OK",
      timestamp: DateTime.utc_now(),
      data: ${SERVICE_MODULE}.run(params)
    })
  end
end
EOF

cat > "$SCHEMA_FILE" <<EOF
defmodule ${SCHEMA_MODULE} do
  @moduledoc "${METHOD_LABEL} ${RESOURCE_LABEL} API schemas."

  alias OpenApiSpex.Schema

  def request_schema do
    %Schema{
      type: :object,
      properties: %{},
      additionalProperties: true
    }
  end

  def data_schema do
    %Schema{
      type: :object,
      properties: %{},
      additionalProperties: true
    }
  end
end
EOF

cat > "$SERVICE_FILE" <<EOF
defmodule ${SERVICE_MODULE} do
  @moduledoc "Application service for ${RESOURCE_LABEL}."

  @spec run(map()) :: map()
  def run(params) do
    params
  end
end
EOF

cat <<EOF
Generated API scaffold:
  - ${CONTROLLER_FILE#$ROOT_DIR/}
  - ${SCHEMA_FILE#$ROOT_DIR/}
  - ${SERVICE_FILE#$ROOT_DIR/}

Next steps:
  1. Add the route to apps/ai_api/lib/ai_api_web/router.ex
  2. Register the OpenAPI path in apps/ai_api/lib/ai_api_web/api_spec.ex when needed
  3. Replace the request/data schema stubs with concrete properties
  4. Replace ${SERVICE_MODULE}.run/1 with real application logic
EOF