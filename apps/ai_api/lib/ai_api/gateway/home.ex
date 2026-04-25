defmodule AiApi.Bff.Home do
  @moduledoc """
  Aggregates frontend-facing data for BFF home/dashboard experiences.
  """

  @spec build() :: map()
  def build do
    %{
      user: %{
        id: "guest",
        name: "Guest"
      },
      features: ["health", "search", "chat"],
      cards: [
        %{id: "system", title: "System", status: "healthy"},
        %{id: "api", title: "API", status: "healthy"}
      ]
    }
  end
end
