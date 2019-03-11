defmodule RoboPirate.EventHandler do
  alias RoboPirate.MessageSender

  def handle_event(%{
        "event" => %{"type" => "channel_created", "channel" => channel_info}
      }) do
    %{"creator" => creator, "id" => channel} = channel_info
    MessageSender.new_channel(creator, channel)
  end

  def handle_event(param = %{"event" => %{"type" => "app_mention"}}) do
    if param["event"]["subtype"] != "bot_message" do
      MessageSender.send_message(
        param["event"]["channel"],
        param["event"]["text"]
      )
    end
  end
end
