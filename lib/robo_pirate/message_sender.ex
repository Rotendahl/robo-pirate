defmodule RoboPirate.MessageSender do
  @announcemnts_id "C0CNF7F0C"
  @url "https://slack.com/api/chat.postMessage"
  @token Application.get_env(:robo_pirate, :bot_token)
  @headers [
    {"Content-Type", "application/json"},
    {"Authorization", "Bearer #{@token}"}
  ]

  def send_message(channel, text) do
    {:ok, body} =
      %{
        "channel" => channel,
        "text" => text
      }
      |> Poison.encode()
    HTTPoison.post(@url, body, @headers)
  end

  def new_channel(creator, channel) do
    message =
      "Ohøj kære pirater!\n" <>
        "<@#{creator}> har lige søsat kanalen <##{channel}> kig ind hvis du " <>
        "synes det lyder spændende!"
    send_message(@announcemnts_id, message)
  end
end
