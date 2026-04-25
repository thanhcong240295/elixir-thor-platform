defmodule AiApiWeb.ApiSchemas.Response do
  @moduledoc "Response-oriented reusable API schemas."

  alias OpenApiSpex.Schema

  @doc "Base success response envelope schema."
  def success_response_schema(data_schema) do
    %Schema{
      type: :object,
      properties: %{
        success: %Schema{type: :boolean, example: true},
        message: %Schema{type: :string, example: "OK"},
        timestamp: %Schema{type: :string, format: :"date-time"},
        data: data_schema
      },
      required: [:success, :message, :timestamp, :data]
    }
  end

  @doc "Standard error response envelope schema."
  def error_response_schema do
    %Schema{
      type: :object,
      properties: %{
        success: %Schema{type: :boolean, example: false},
        message: %Schema{type: :string, example: "Validation failed"},
        timestamp: %Schema{type: :string, format: :"date-time"},
        error: %Schema{
          type: :object,
          properties: %{
            code: %Schema{type: :string, example: "BAD_REQUEST"},
            details: %Schema{type: :string, example: "Missing required field"}
          },
          required: [:code]
        }
      },
      required: [:success, :message, :timestamp, :error]
    }
  end
end
