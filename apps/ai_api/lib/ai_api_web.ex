defmodule AiApiWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use AiApiWeb, :controller
      use AiApiWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, formats: [:html, :json]

      use Gettext, backend: AiApiWeb.Gettext

      import Plug.Conn

      unquote(verified_routes())
    end
  end

  def api_controller do
    quote do
      use Phoenix.Controller, formats: [:json]

      use Gettext, backend: AiApiWeb.Gettext

      import Plug.Conn

      plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true

      unquote(verified_routes())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: AiApiWeb.Endpoint,
        router: AiApiWeb.Router,
        statics: AiApiWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
