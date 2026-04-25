defmodule AiApiWeb.ApiSchemas.Gateway.AdminHome do
  @moduledoc "Admin gateway home schema."

  alias OpenApiSpex.Schema

  def data_schema do
    %Schema{
      type: :object,
      properties: %{
        user: %Schema{
          type: :object,
          properties: %{
            id: %Schema{type: :string},
            role: %Schema{type: :string}
          },
          required: [:id, :role]
        },
        pending_approvals: %Schema{type: :integer},
        metrics: %Schema{
          type: :object,
          properties: %{
            active_users: %Schema{type: :integer},
            failed_jobs: %Schema{type: :integer},
            queue_depth: %Schema{type: :integer}
          },
          required: [:active_users, :failed_jobs, :queue_depth]
        }
      },
      required: [:user, :pending_approvals, :metrics]
    }
  end
end
