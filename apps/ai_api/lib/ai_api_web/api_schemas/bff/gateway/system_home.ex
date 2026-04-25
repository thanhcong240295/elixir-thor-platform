defmodule AiApiWeb.ApiSchemas.Bff.Gateway.SystemHome do
  @moduledoc "System gateway BFF schema."

  alias OpenApiSpex.Schema

  def data_schema do
    %Schema{
      type: :object,
      properties: %{
        environment: %Schema{type: :string},
        services: %Schema{
          type: :array,
          items: %Schema{
            type: :object,
            properties: %{
              name: %Schema{type: :string},
              status: %Schema{type: :string}
            },
            required: [:name, :status]
          }
        },
        incidents_open: %Schema{type: :integer}
      },
      required: [:environment, :services, :incidents_open]
    }
  end
end
