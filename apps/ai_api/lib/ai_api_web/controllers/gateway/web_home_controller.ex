defmodule AiApiWeb.Gateway.WebHomeController do
  use AiApiWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias AiApi.Gateway.Web.Home
  alias AiApiWeb.ApiSchemas
  alias AiApiWeb.ApiSchemas.Gateway.WebHome, as: WebHomeSchema
  alias AiApiWeb.Gateway.HomeResponder

  tags(["gateway-web"])

  operation(:show,
    operation_id: "AiApiWeb.Gateway.WebHomeController.show",
    summary: "Web user BFF home payload",
    description: "Returns frontend-tailored aggregate data for web users.",
    responses: [
      ok: {
        "Web user BFF response",
        "application/json",
        ApiSchemas.success_response_schema(WebHomeSchema.data_schema())
      }
    ]
  )

  def show(conn, _params) do
    HomeResponder.render(conn, Home)
  end
end
