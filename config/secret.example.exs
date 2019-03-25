System.put_env(
  "SLACK_TOKEN",
  "xxxx"
)

System.put_env(
  "BOT_TOKEN",
  "xxxx"
)

System.put_env(
  "SIGN_SECRET",
  "xxxx"
)

System.put_env(
  "PORT",
  "4000"
)

System.put_env(
  "MAX_AGE", # The maximum age of a request in seconds before we rejct it,
  # should be low in production to stop replay attacks but large in development
  # and testing where we do use replays.
  "315360000" # 10 years,
)

System.put_env(
  "OAUTH_TOKEN",
  "xxxx"
)

System.put_env(
  "LEGACY_TOKEN",
  "xxxx"
)

System.put_env(
  "VOLUNTEER_CHANNELS",
  "xxxx, xxxx"
)

System.put_env(
  "CHILD_CHANNELS",
  "xxxx, xxxx"
)

System.put_env(
  "BOARD",
  # Slack user names
  "bob, alice, etc"
)

System.put_env(
  "SLACK_URL",
  # Set to localhost in dev
  "https://slack.com/api/"
)

System.put_env(
  "ANNOUNCEMNTS_ID",
  "xxxx"
)

System.put_env(
  "INVITE_THREAD",
  "xxxx"
)
