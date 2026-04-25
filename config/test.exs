import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ai_api, AiApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  server: false

config :ai_api, AiApi.Repo,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  hostname: System.get_env("DB_HOST"),
  port: String.to_integer(System.get_env("DB_PORT")),
  database: System.get_env("DB_NAME_TEST"),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: String.to_integer(System.get_env("POOL_SIZE"))

config :ai_api, AiApi.Repo.Read,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  hostname: System.get_env("DB_HOST_READ"),
  port: String.to_integer(System.get_env("DB_PORT_READ")),
  database: System.get_env("DB_NAME_TEST"),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: String.to_integer(System.get_env("POOL_SIZE_READ"))

config :ai_api, :redis_url, System.get_env("REDIS_URL_TEST")
config :ai_api, :redis_read_url, System.get_env("REDIS_READ_URL_TEST")

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Sort query params output of verified routes for robust url comparisons
config :phoenix,
  sort_verified_routes_query_params: true
