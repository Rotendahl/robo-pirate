# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :robo_pirate, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:robo_pirate, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
use Mix.Config

if File.exists?("config/secret.exs") do
  import_config "secret.exs"
end

if Mix.env() == :test do
  import_config "test.exs"
end

config :robo_pirate, slack_token: System.get_env("SLACK_TOKEN")
config :robo_pirate, bot_token: System.get_env("BOT_TOKEN")
config :robo_pirate, port: System.get_env("PORT")

config :robo_pirate, slack_url: System.get_env("SLACK_URL")

config :robo_pirate, announcemnts_id: System.get_env("announcemnts_id")

config :robo_pirate, board: System.get_env("BOARD")
  |> String.replace(" ", "")
  |> String.split(",")
