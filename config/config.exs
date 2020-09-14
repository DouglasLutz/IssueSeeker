# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :issue_seeker,
  ecto_repos: [IssueSeeker.Repo]

# Configures the endpoint
config :issue_seeker, IssueSeekerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7v6FXuBcuSC3CyyyUZyq/sA9uq9amOReFppMHmZa+7DgB9wicGAMgHrCgiNABAZs",
  render_errors: [view: IssueSeekerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: IssueSeeker.PubSub,
  live_view: [signing_salt: "Y4OJtwLm"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [github: {Ueberauth.Strategy.Github, [default_scope: "user:email"]}]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
