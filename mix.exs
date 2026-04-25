defmodule ElixirThorPlatform.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      releases: releases(),
      deps: deps()
    ]
  end

  defp releases do
    [
      ai_api: [
        applications: [
          ai_api: :permanent
        ]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      # AI & GPU libraries
      {:nx, "~> 0.9"},
      {:exla, "~> 0.9"},
      {:axon, "~> 0.7"},
      {:bumblebee, "~> 0.6"},

      # Database
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:pgvector, "~> 0.3.0"},

      # Caching and message brokering
      {:redix, "~> 1.5"},
      {:castore, ">= 0.0.0"},

      # Web
      {:cors_plug, "~> 3.0", override: true}
    ]
  end
end
