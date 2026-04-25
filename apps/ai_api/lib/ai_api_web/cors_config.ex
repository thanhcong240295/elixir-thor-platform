defmodule AiApiWeb.CorsConfig do
  @moduledoc """
  Reads allowed CORS origins from the CORS_ORIGINS environment variable
  at runtime. Comma-separated list of origins.

  Example:
      CORS_ORIGINS=https://app.example.com,https://admin.example.com
  """

  def origins do
    case System.get_env("CORS_ORIGINS") do
      nil -> []
      "" -> []
      origins -> String.split(origins, ",", trim: true)
    end
  end
end
