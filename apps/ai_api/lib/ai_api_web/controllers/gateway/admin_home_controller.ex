defmodule AiApiWeb.Gateway.AdminHomeController do
  use AiApiWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias AiApi.Gateway.Admin.Home
  alias AiApiWeb.ApiSchemas
  alias AiApiWeb.ApiSchemas.Gateway.AdminHome, as: AdminHomeSchema
  alias AiApiWeb.Gateway.HomeResponder

  tags(["gateway-admin"])

  operation(:show,
    operation_id: "AiApiWeb.Gateway.AdminHomeController.show",
    summary: "Admin BFF home payload",
    description: "Returns frontend-tailored aggregate data for the admin panel.",
    responses: [
      ok: {
        "Admin BFF response",
        "application/json",
        ApiSchemas.success_response_schema(AdminHomeSchema.data_schema())
      }
    ]
  )

  def show(conn, _params) do
    HomeResponder.render(conn, Home)
  end
end
