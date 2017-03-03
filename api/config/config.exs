# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :bookbump,
  ecto_repos: [Bookbump.Repo]

# Configures the endpoint
config :bookbump, Bookbump.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IaBxIve0JNKfHZnjkDPCw2qCMy2BDIdPm24HaVjxFFomVGrxRHc+dip5990Bab3u",
  render_errors: [view: Bookbump.ErrorView, accepts: ~w(json)],
  pubsub: [name: Bookbump.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Guardian for JSON Web Tokens
config :guardian, Guardian,
  issuer: "Bookbump",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: Bookbump.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
