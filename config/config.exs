use Mix.Config

if Mix.env() == :dev do
  import_config "secret.exs"
end

if Mix.env() == :test do
  import_config "secret.exs"
  import_config "test.exs"
end

config :robo_pirate, slack_token: System.get_env("SLACK_TOKEN")
config :robo_pirate, bot_token: System.get_env("BOT_TOKEN")
config :robo_pirate, oauth_token: System.get_env("OAUTH_TOKEN")
config :robo_pirate, port: System.get_env("PORT")
config :robo_pirate, sign_secret: System.get_env("SIGN_SECRET")
config :robo_pirate, legacy_token: System.get_env("LEGACY_TOKEN")
config :robo_pirate, slack_url: System.get_env("SLACK_URL")
config :robo_pirate, invite_channel: System.get_env("INVITE_THREAD")
config :robo_pirate, announcemnts_id: System.get_env("ANNOUNCEMNTS_ID")
config :robo_pirate, volunteer_channels: System.get_env("VOLUNTEER_CHANNELS")
config :robo_pirate, child_channels: System.get_env("CHILD_CHANNELS")
config :robo_pirate, max_age: System.get_env("MAX_AGE") |> String.to_integer

config :robo_pirate,
  board:
    System.get_env("BOARD")
    |> String.replace(" ", "")
    |> String.split(",")
