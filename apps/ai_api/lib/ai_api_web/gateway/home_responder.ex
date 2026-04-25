defmodule AiApiWeb.Gateway.HomeResponder do
  @moduledoc false

  import Phoenix.Controller, only: [json: 2]

  def render(conn, builder_module) do
    json(conn, %{
      success: true,
      message: "OK",
      timestamp: DateTime.utc_now(),
      data: builder_module.build()
    })
  end
end
