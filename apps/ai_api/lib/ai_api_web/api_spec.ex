defmodule AiApiWeb.ApiSpec do
  @moduledoc """
  OpenAPI 3.0 specification for the AI API.
  """

  alias OpenApiSpex.{Info, OpenApi, Operation, PathItem, Paths, Server}
  alias AiApiWeb.Router

  @behaviour OpenApi

  @impl OpenApi
  def spec do
    admin_home_operation = controller_operation(AiApiWeb.Gateway.AdminHomeController, :show)
    system_home_operation = controller_operation(AiApiWeb.Gateway.SystemHomeController, :show)
    web_home_operation = controller_operation(AiApiWeb.Gateway.WebHomeController, :show)

    paths =
      Router
      |> Paths.from_router()
      |> maybe_put_gateway_home_path("/v1/admin/home", admin_home_operation)
      |> maybe_put_gateway_home_path("/v1/system/home", system_home_operation)
      |> maybe_put_gateway_home_path("/v1/web/home", web_home_operation)

    %OpenApi{
      servers: [
        %Server{url: "/"}
      ],
      info: %Info{
        title: "AI API",
        version: "1.0.0",
        description: "API for the Elixir Thor AI Platform"
      },
      paths: paths
    }
    |> OpenApiSpex.resolve_schema_modules()
  end

  defp maybe_put_gateway_home_path(paths, path, %Operation{} = operation) do
    Map.put(paths, path, %PathItem{get: operation})
  end

  defp maybe_put_gateway_home_path(paths, _path, _), do: paths

  defp controller_operation(controller, action) do
    case controller.open_api_operation(action) do
      operation = %Operation{} -> operation
      _ -> nil
    end
  end
end
