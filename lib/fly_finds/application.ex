defmodule FlyFinds.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FlyFindsWeb.Telemetry,
      FlyFinds.Repo,
      {DNSCluster, query: Application.get_env(:fly_finds, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FlyFinds.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FlyFinds.Finch},
      # Start a worker by calling: FlyFinds.Worker.start_link(arg)
      # {FlyFinds.Worker, arg},
      # Start to serve requests, typically the last entry
      FlyFindsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FlyFinds.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FlyFindsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
