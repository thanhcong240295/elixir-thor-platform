defmodule AiApiWeb.Gateway.SystemHomeController do
  use AiApiWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias AiApi.Gateway.System.Home
  alias AiApiWeb.ApiSchemas
  alias AiApiWeb.ApiSchemas.Gateway.SystemHome, as: SystemHomeSchema
  alias AiApiWeb.Gateway.HomeResponder

  tags(["gateway-system"])

  operation(:show,
    operation_id: "AiApiWeb.Gateway.SystemHomeController.show",
    summary: "System BFF home payload",
    description: "Returns frontend-tailored aggregate data for the system control panel.",
    responses: [
      ok: {
        "System BFF response",
        "application/json",
        ApiSchemas.success_response_schema(SystemHomeSchema.data_schema())
      }
    ]
  )

  def show(conn, _params) do
    HomeResponder.render(conn, Home)
  end
end
