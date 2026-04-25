defmodule AiApiWeb.ApiSchemas.Health do
  @moduledoc "Health endpoint schemas."

  alias OpenApiSpex.Schema

  @doc "Health endpoint data payload schema."
  def health_data_schema do
    %Schema{
      type: :object,
      properties: %{
        pong: %Schema{type: :boolean}
      },
      required: [:pong]
    }
  end
end
