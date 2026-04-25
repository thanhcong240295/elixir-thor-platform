# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ai_api,
  generators: [timestamp_type: :utc_datetime]

config :ai_api,
  ecto_repos: [AiApi.Repo, AiApi.Repo.Read]

config :ai_api, AiApi.Repo,
  migration_primary_key: [type: :id],
  migration_timestamps: [type: :utc_datetime]

config :ai_api, AiApi.Repo.Read,
  migration_primary_key: [type: :id],
  migration_timestamps: [type: :utc_datetime]

config :ai_api, :redis_url, "redis://127.0.0.1:6379/0"
config :ai_api, :redis_read_url, "redis://127.0.0.1:6380/0"

# Configure the endpoint
config :ai_api, AiApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: AiApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: AiApi.PubSub,
  live_view: [signing_salt: "A3HlpLqP"]

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#

# Configure Nx to use EXLA as the default backend
config :nx, :default_backend, EXLA.Backend

# Configure EXLA to use CUDA (GPU)
config :exla, :default_client, :cuda

# Memory options to help avoid VRAM exhaustion
config :exla, :clients,
  cuda: [
    platform: :cuda,
    # Use up to 80% of GPU memory
    memory_fraction: 0.8
  ]
