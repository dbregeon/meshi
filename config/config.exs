# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :meshi,
  ecto_repos: [Meshi.Repo],
  incoming_slack_webhook: System.get_env("SLACK_INCOMING_WEBHOOK"),
  slack_token: System.get_env("SLACK_TOKEN")

# Configures the endpoint
config :meshi, Meshi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NO4ZET090zdLZoUFCCXRKxrTPeS8cAbN257YaSoPkdM4ekmaCBGwGY0dqdDvFXw9",
  render_errors: [view: Meshi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Meshi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  # hd option for google restricts the domain of the users.
  providers: [google: {Ueberauth.Strategy.Google, [default_scope: "email profile", hd: System.get_env("USERS_DOMAIN")]}]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

config :meshi, Meshi.Guardian,
  issuer: "Meshi.#{Mix.env}",
  ttl: {30, :days},
  verify_issuer: true,
  secret_key: to_string(Mix.env)

config :meshi, Guardian.AuthPipeline,
  module: Meshi.Guardian,
  error_handler: Meshi.AuthErrorHandler

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
