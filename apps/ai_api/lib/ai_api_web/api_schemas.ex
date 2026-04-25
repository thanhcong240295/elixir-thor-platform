defmodule AiApiWeb.ApiSchemas do
  @moduledoc """
  Reusable OpenAPI schemas for consistent request/response contracts.
  """

  alias AiApiWeb.ApiSchemas.{Health, Request, Response}

  @doc "Base schema for common API request metadata."
  defdelegate base_request_schema(), to: Request

  @doc "Base success response envelope schema."
  defdelegate success_response_schema(data_schema), to: Response

  @doc "Standard error response envelope schema."
  defdelegate error_response_schema(), to: Response

  @doc "Health endpoint data payload schema."
  defdelegate health_data_schema(), to: Health
end
