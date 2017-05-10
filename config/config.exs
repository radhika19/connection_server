# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :connectionserver,
  ecto_repos: [Connectionserver.Repo]

# Configures the endpoint
config :connectionserver, Connectionserver.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "W24cicoFBHj581Gug0NDuIPjCrecZWZHb1nZjT7isV5VvUAMgg9glzJ4pr4XFxs5",
  render_errors: [view: Connectionserver.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Connectionserver.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
