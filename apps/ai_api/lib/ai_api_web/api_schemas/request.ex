defmodule AiApiWeb.ApiSchemas.Request do
  @moduledoc "Request-oriented reusable API schemas."

  alias OpenApiSpex.Schema

  @doc "Base schema for common API request metadata."
  def base_request_schema do
    %Schema{
      type: :object,
      properties: %{
        meta: %Schema{
          type: :object,
          properties: %{
            request_id: %Schema{type: :string, description: "Client-generated request id"},
            locale: %Schema{type: :string, description: "Request locale (e.g. en-US)"},
            client_version: %Schema{type: :string, description: "Client app version"}
          }
        },
        data: %Schema{type: :object}
      },
      required: [:data]
    }
  end
end
