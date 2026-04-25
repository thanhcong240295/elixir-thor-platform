defmodule AiApi.Repo.Read do
  use Ecto.Repo,
    otp_app: :ai_api,
    adapter: Ecto.Adapters.Postgres,
    read_only: true
end
