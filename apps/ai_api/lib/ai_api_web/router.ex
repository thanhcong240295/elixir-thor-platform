defmodule AiApiWeb.Router do
  use AiApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: AiApiWeb.ApiSpec
    plug AiApiWeb.Plugs.Security.BlockedIP
    plug AiApiWeb.Plugs.Traffic.RateLimit
    plug AiApiWeb.Plugs.OpenApi.ResponseValidate
  end

  pipeline :open_api_spex do
    plug AiApiWeb.Plugs.OpenApi.RefreshCache
    plug OpenApiSpex.Plug.PutApiSpec, module: AiApiWeb.ApiSpec
  end

  pipeline :dev_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :protect_from_forgery
  end

  pipeline :dashboard_auth do
    plug :require_dashboard_basic_auth
  end

  scope "/v1", AiApiWeb do
    pipe_through :api

    get "/health", HealthController, :ping
  end

  scope "/v1", AiApiWeb.Gateway do
    pipe_through :api

    get "/admin/home", AdminHomeController, :show
    get "/system/home", SystemHomeController, :show
    get "/web/home", WebHomeController, :show
  end

  # Enable LiveDashboard and Swagger UI in development
  if Application.compile_env(:ai_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:dev_browser, :dashboard_auth]

      live_dashboard "/dashboard", metrics: AiApiWeb.Telemetry
    end

    scope "/dev" do
      pipe_through [:dev_browser, :open_api_spex]

      get "/openapi", OpenApiSpex.Plug.RenderSpec, []
      get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/dev/openapi"
    end
  end

  defp require_dashboard_basic_auth(conn, _opts) do
    username = System.get_env("DASHBOARD_BASIC_AUTH_USER")
    password = System.get_env("DASHBOARD_BASIC_AUTH_PASS")

    case {username, password} do
      {u, p} when is_binary(u) and is_binary(p) ->
        Plug.BasicAuth.basic_auth(conn, username: u, password: p)

      {nil, nil} ->
        # In local dev, allow dashboard access when auth vars are not configured.
        conn

      _ ->
        raise "Set both DASHBOARD_BASIC_AUTH_USER and DASHBOARD_BASIC_AUTH_PASS, or unset both"
    end
  end
end
