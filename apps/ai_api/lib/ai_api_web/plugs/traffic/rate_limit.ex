defmodule AiApiWeb.Plugs.Traffic.RateLimit do
  @moduledoc """
  Rate limiting plug using PlugAttack with ETS storage.

  Limits are configured via application env:
    - :rate_limit_requests — max requests per window (default 100)
    - :rate_limit_window_ms — window in milliseconds (default 60_000)
  """

  use PlugAttack

  # Keep a stable ETS table name so runtime reloads and module refactors
  # do not break throttling table lookup.
  @storage_table AiApiWeb.Plugs.RateLimit.Storage

  rule "throttle by IP", conn do
    requests = Application.get_env(:ai_api, :rate_limit_requests, 100)
    window_ms = Application.get_env(:ai_api, :rate_limit_window_ms, 60_000)

    throttle(conn.remote_ip,
      period: window_ms,
      limit: requests,
      storage: {PlugAttack.Storage.Ets, @storage_table}
    )
  end

  def allow_action(conn, {:throttle, data}, _opts) do
    conn
    |> Plug.Conn.put_resp_header("x-ratelimit-limit", to_string(data[:limit]))
    |> Plug.Conn.put_resp_header("x-ratelimit-remaining", to_string(data[:remaining]))
    |> Plug.Conn.put_resp_header(
      "x-ratelimit-reset",
      to_string(reset_at_unix(data[:reset_at]))
    )
  end

  def block_action(conn, {:throttle, _data}, _opts) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(429, Jason.encode!(%{error: "too_many_requests"}))
    |> Plug.Conn.halt()
  end

  defp reset_at_unix(%DateTime{} = reset_at), do: DateTime.to_unix(reset_at)

  defp reset_at_unix(reset_at) when is_integer(reset_at) do
    case DateTime.from_unix(reset_at, :millisecond) do
      {:ok, dt} -> DateTime.to_unix(dt)
      {:error, _reason} -> reset_at
    end
  end

  defp reset_at_unix(_reset_at), do: 0
end
