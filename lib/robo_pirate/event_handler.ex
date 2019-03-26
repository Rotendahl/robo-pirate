defmodule RoboPirate.EventHandler do
  @moduledoc """
    Module that handles all events by calling other functions.
    They should all return {:ok, msg} or {:error, reasons}
  """

  alias RoboPirate.MessageSender

  def handle_event(%{"type" => "channel_created", "channel" => channel_info}) do
    %{"creator" => creator, "id" => channel} = channel_info
    MessageSender.new_channel(creator, channel)
  end

  def handle_event(%{"type" => "app_mention", "subtype" => "bot_message"}) do
    {:ok, "bot_message"}
  end

  def handle_event(event = %{"type" => "app_mention"}) do
    %{"text" => _text, "channel" => channel, "user" => _user} = event
    MessageSender.dont_understand(channel)
  end
end
