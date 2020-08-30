defmodule IssueSeeker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      IssueSeeker.Repo,
      # Start the Telemetry supervisor
      IssueSeekerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: IssueSeeker.PubSub},
      # Start the Endpoint (http/https)
      IssueSeekerWeb.Endpoint
      # Start a worker by calling: IssueSeeker.Worker.start_link(arg)
      # {IssueSeeker.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: IssueSeeker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    IssueSeekerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
