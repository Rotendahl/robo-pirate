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
      %{"text" => text, "channel" => channel, "user" => user} = param["event"]

      cond do
        text =~ "vote" and (text =~ "public" or text =~ "private") ->
          [_, "vote", privacy | tail] = text |> String.split(" ")
          proposal = tail |> Enum.join(" ")

          if privacy == "public" or privacy == "private" do
            MessageSender.vote(user, privacy, proposal)
          else
            ("Ups, den forstod jeg ikke\n" <>
               "Du skal skrive \`vote public/private skal vi have en øl\`")
            |> MessageSender.send_message(channel)
          end

        true ->
          MessageSender.dont_understand(channel)
      end
    end
  end
end
