defmodule AiApi.Gateway.Admin.Home do
  @moduledoc """
  Admin frontend aggregate payload.
  """

  @spec build() :: map()
  def build do
    %{
      user: %{id: "admin-1", role: "admin"},
      pending_approvals: 3,
      metrics: %{
        active_users: 124,
        failed_jobs: 1,
        queue_depth: 9
      }
    }
  end
end
