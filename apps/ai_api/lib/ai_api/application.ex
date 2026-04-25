defmodule AiApi.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AiApiWeb.Telemetry,
      AiApi.Repo,
      AiApi.Repo.Read,
      {PlugAttack.Storage.Ets, name: AiApiWeb.Plugs.RateLimit.Storage, clean_period: 60_000},
      Supervisor.child_spec(
        {Redix, {Application.fetch_env!(:ai_api, :redis_url), [name: AiApi.Cache.Redix]}},
        id: :redix_primary
      ),
      Supervisor.child_spec(
        {Redix,
         {Application.fetch_env!(:ai_api, :redis_read_url), [name: AiApi.Cache.RedixRead]}},
        id: :redix_read
      ),
      {DNSCluster, query: Application.get_env(:ai_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AiApi.PubSub},
      AiApiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: AiApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    AiApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
