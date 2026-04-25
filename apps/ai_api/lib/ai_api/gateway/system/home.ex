defmodule AiApi.Gateway.System.Home do
  @moduledoc """
  System control frontend aggregate payload.
  """

  @spec build() :: map()
  def build do
    %{
      environment: "dev",
      services: [
        %{name: "api", status: "healthy"},
        %{name: "redis", status: "healthy"},
        %{name: "worker", status: "degraded"}
      ],
      incidents_open: 1
    }
  end
end
