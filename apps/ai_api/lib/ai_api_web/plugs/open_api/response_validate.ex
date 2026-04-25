defmodule AiApiWeb.Plugs.OpenApi.ResponseValidate do
  @moduledoc """
  Validates JSON response bodies against OpenAPI operation response schemas.

  This plug requires OpenApiSpex.Plug.PutApiSpec and
  OpenApiSpex.Plug.CastAndValidate to have run earlier in the pipeline.
  """

  import Plug.Conn

  alias OpenApiSpex.{OpenApi, Operation, Reference}
  alias OpenApiSpex.Cast.{Error, Utils}
  alias OpenApiSpex.Plug.PutApiSpec

  @json_content_regex ~r/^application\/json/i

  def init(opts), do: opts

  def call(conn, _opts) do
    register_before_send(conn, &validate_response/1)
  end

  defp validate_response(%Plug.Conn{halted: true} = conn), do: conn

  defp validate_response(conn = %{private: %{open_api_spex: _}}) do
    with {:ok, spec, operation} <- fetch_spec_and_operation(conn),
         {:ok, schema} <- resolve_response_schema(conn, operation, spec),
         {:ok, body} <- decode_body(conn),
         :ok <- validate_body(body, schema, spec) do
      conn
    else
      :skip ->
        conn

      {:error, message} ->
        conn
        |> put_resp_content_type("application/json")
        |> resp(500, Jason.encode!(%{error: "invalid_response", detail: message}))
    end
  end

  defp validate_response(conn), do: conn

  defp fetch_spec_and_operation(conn) do
    {spec, operation_lookup} = PutApiSpec.get_spec_and_operation_lookup(conn)
    operation_id = conn.private.open_api_spex[:operation_id]

    case operation_lookup[operation_id] do
      operation = %Operation{} -> {:ok, spec, operation}
      _ -> :skip
    end
  end

  defp resolve_response_schema(conn, operation, spec) do
    content_type = Utils.content_type_from_header(conn, :response)
    responses = Map.get(operation, :responses, %{})
    code_range = String.first(to_string(conn.status)) <> "XX"

    response =
      Map.get(responses, conn.status) ||
        Map.get(responses, "#{conn.status}") ||
        Map.get(responses, :"#{conn.status}") ||
        Map.get(responses, code_range) ||
        Map.get(responses, :"#{code_range}")

    resolved_response =
      case response do
        %Reference{} = ref ->
          OpenApiSpex.Reference.resolve_response(ref, spec.components.responses)

        value ->
          value
      end

    schema =
      resolved_response
      |> Kernel.||(%{})
      |> Map.get(:content, %{})
      |> Map.get(content_type, %{})
      |> Map.get(:schema)

    if is_nil(schema), do: :skip, else: {:ok, schema}
  end

  defp decode_body(conn) do
    content_type = Utils.content_type_from_header(conn, :response)

    cond do
      conn.status == 204 ->
        :skip

      is_nil(conn.resp_body) or conn.resp_body == "" ->
        {:ok, nil}

      is_binary(content_type) and String.match?(content_type, @json_content_regex) ->
        {:ok, OpenApi.json_encoder().decode!(conn.resp_body)}

      true ->
        {:ok, conn.resp_body}
    end
  end

  defp validate_body(body, schema, spec) do
    case OpenApiSpex.cast_value(body, schema, spec, read_write_scope: :read) do
      {:ok, _} ->
        :ok

      {:error, errors} ->
        {:error, format_errors(errors)}
    end
  end

  defp format_errors(errors) when is_list(errors) do
    errors
    |> Enum.map(fn
      %Error{} = err -> OpenApiSpex.error_message(err)
      other -> inspect(other)
    end)
    |> Enum.join("; ")
  end

  defp format_errors(other), do: inspect(other)
end
