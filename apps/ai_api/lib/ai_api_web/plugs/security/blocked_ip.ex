defmodule AiApiWeb.Plugs.Security.BlockedIP do
  @moduledoc """
    Restricts requests using optional allowlist and blocklist application config.

    If :allowed_ips is configured, only those IPs are allowed.
    Requests from IPs in :blocked_ips are always denied.

  Configure in config.exs or runtime.exs:

      config :ai_api, :allowed_ips, ["127.0.0.1", "172.20.0.2"]
      config :ai_api, :blocked_ips, ["1.2.3.4", "5.6.7.8"]

    Or via env vars (comma-separated):

      ALLOWED_IPS=127.0.0.1,172.20.0.2
      BLOCKED_IPS=1.2.3.4,5.6.7.8
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    allowed = allowed_ips()
    blocked = blocked_ips()
    remote_ip = conn.remote_ip |> :inet.ntoa() |> to_string()

    cond do
      remote_ip in blocked ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(403, Jason.encode!(%{error: "forbidden"}))
        |> halt()

      allowed != [] and remote_ip not in allowed ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(403, Jason.encode!(%{error: "forbidden"}))
        |> halt()

      true ->
        conn
    end
  end

  defp allowed_ips do
    env_ips =
      case System.get_env("ALLOWED_IPS") do
        nil -> []
        "" -> []
        ips -> String.split(ips, ",", trim: true)
      end

    config_ips = Application.get_env(:ai_api, :allowed_ips, [])

    Enum.uniq(env_ips ++ config_ips)
  end

  defp blocked_ips do
    env_ips =
      case System.get_env("BLOCKED_IPS") do
        nil -> []
        "" -> []
        ips -> String.split(ips, ",", trim: true)
      end

    config_ips = Application.get_env(:ai_api, :blocked_ips, [])

    Enum.uniq(env_ips ++ config_ips)
  end
end
