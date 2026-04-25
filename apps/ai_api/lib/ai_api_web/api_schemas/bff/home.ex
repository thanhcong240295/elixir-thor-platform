defmodule AiApiWeb.ApiSchemas.Bff.Home do
  @moduledoc "BFF home response schemas."

  alias OpenApiSpex.Schema

  @doc "BFF home payload schema."
  def data_schema do
    %Schema{
      type: :object,
      properties: %{
        user: %Schema{
          type: :object,
          properties: %{
            id: %Schema{type: :string},
            name: %Schema{type: :string}
          },
          required: [:id, :name]
        },
        features: %Schema{type: :array, items: %Schema{type: :string}},
        cards: %Schema{
          type: :array,
          items: %Schema{
            type: :object,
            properties: %{
              id: %Schema{type: :string},
              title: %Schema{type: :string},
              status: %Schema{type: :string}
            },
            required: [:id, :title, :status]
          }
        }
      },
      required: [:user, :features, :cards]
    }
  end
end
