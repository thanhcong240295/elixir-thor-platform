defmodule AiApi.Gateway.Web.Home do
  @moduledoc """
  Web user frontend aggregate payload.
  """

  @spec build() :: map()
  def build do
    %{
      profile: %{id: "user-1", name: "Guest"},
      quick_actions: ["chat", "history", "settings"],
      feed: [
        %{id: "welcome", title: "Welcome", kind: "info"},
        %{id: "tips", title: "Tips", kind: "guide"}
      ]
    }
  end
end
