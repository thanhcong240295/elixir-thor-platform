defmodule AiApi.Repo do
  use Ecto.Repo,
    otp_app: :ai_api,
    adapter: Ecto.Adapters.Postgres
end
