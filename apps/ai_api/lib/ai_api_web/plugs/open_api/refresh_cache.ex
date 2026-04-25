defmodule AiApiWeb.Plugs.OpenApi.RefreshCache do
  @moduledoc """
  Refreshes OpenApiSpex cache on each request in dev-like environments.

  This avoids stale operation lookups while routes/specs are changing.
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    cache_adapter = OpenApiSpex.Plug.Cache.adapter()

    if function_exported?(cache_adapter, :erase, 1) do
      cache_adapter.erase(AiApiWeb.ApiSpec)
    end

    conn
  end
end
