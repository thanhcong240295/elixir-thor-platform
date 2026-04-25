defmodule AiApiWeb.ApiSchemas.Bff.Gateway.WebHome do
  @moduledoc "Web user gateway BFF schema."

  alias OpenApiSpex.Schema

  def data_schema do
    %Schema{
      type: :object,
      properties: %{
        profile: %Schema{
          type: :object,
          properties: %{
            id: %Schema{type: :string},
            name: %Schema{type: :string}
          },
          required: [:id, :name]
        },
        quick_actions: %Schema{type: :array, items: %Schema{type: :string}},
        feed: %Schema{
          type: :array,
          items: %Schema{
            type: :object,
            properties: %{
              id: %Schema{type: :string},
              title: %Schema{type: :string},
              kind: %Schema{type: :string}
            },
            required: [:id, :title, :kind]
          }
        }
      },
      required: [:profile, :quick_actions, :feed]
    }
  end
end
