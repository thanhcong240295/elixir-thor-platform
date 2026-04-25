defmodule AiApiWeb.HealthController do
  use AiApiWeb, :api_controller
  use OpenApiSpex.ControllerSpecs

  alias AiApiWeb.ApiSchemas

  tags(["health"])

  operation(:ping,
    summary: "Health check",
    description: "Returns the current server status and timestamp.",
    responses: [
      ok: {
        "Health check response",
        "application/json",
        ApiSchemas.success_response_schema(ApiSchemas.health_data_schema())
      }
    ]
  )

  def ping(conn, _params) do
    json(conn, %{
      pong: true,
      success: true,
      message: "OK",
      timestamp: DateTime.utc_now(),
      data: %{pong: true}
    })
  end
end
