defmodule RoboPirate.MessageSender do
  @announcemnts_id "C0CNF7F0C"
  @url "https://slack.com/api/chat.postMessage"
  @token Application.get_env(:robo_pirate, :bot_token)
  @headers [
    {"Content-Type", "application/json"},
    {"Authorization", "Bearer #{@token}"}
  ]
  @priv_vote_channel "CGUM3F5AM"
  @pub_vote_channel "GGV8NHXT4"

  def send_message(text, channel) do
    {:ok, body} =
      %{
        "channel" => channel,
        "text" => text
      }
      |> Poison.encode()
    IO.inspect "Sending message"
    IO.inspect HTTPoison.post(@url, body, @headers)
  end

  def new_channel(creator, channel) do
    message =
      "Ohøj kære pirater!\n" <>
        "<@#{creator}> har lige søsat kanalen <##{channel}> kig ind hvis du " <>
        "synes det lyder spændende!"
    send_message(message, @announcemnts_id)
  end

  def dont_understand(channel) do
    "Den forstod jeg ikke helt :cry:"
    |> send_message(channel)
  end

  def vote(user, privacy, proposal) do
    # TODO fix this
    {priv, channel} = if privacy == "private" do
      {"Privat forslag fremstillet\n", @priv_vote_channel}
    else
      {"Offentligt forslag fremstillet\n", @pub_vote_channel}
    end
    {:ok, payload} = %{
      "title" => priv,
      "text" => "Forslag stillet af <@#{user}>",
      "channel" => channel,
      "attachments" => [%{
        "text" => proposal,
        "fallback" => "Du fik ikke stemt",
        "callback_id" => "forslag",
        "color" => "#2CA1CC",
        "attachment_type" => "default",
        "actions" => [
            %{
              "name" => "Ja",
              "text" => "Ja",
              "type" => "button",
              "value" => "for"
            },
            %{
              "name" => "Nej",
              "text" => "Nej",
              "type" => "button",
              "value" => "imod"
            },
            %{
              "name" => "Blank",
              "text" => "Blankt",
              "type" => "button",
              "value" => "blank"
            }
          ]
        },
      %{
        "text"=> "Stemmer for:",
        "color" => "#0F795B",
        "id" => "Ja"
      },
      %{
        "text"=> "Stemmer imod:",
        "color" => "#EE92AE",
        "id" => "Nej"
      },
      %{
        "text"=> "Stemmer blankt:",
        "color" => "#AAAAAA",
        "id" => "Blank"
      }
    ]
    } |> Poison.encode()
    {:ok, resp} = HTTPoison.post(@url, payload, @headers)
    %HTTPoison.Response{status_code: 200, body: body} = resp
    {:ok, %{"ts"=> thead_id}} = Poison.decode(body)
    {:ok, thread_payload} = %{
      "channel" => channel,
      "thread_ts" => thead_id,
      "text" => "Tag og stem folkens! " <> Enum.reduce(
        Application.get_env(:robo_pirate, :board) , "",
        fn x,acc -> acc <> "<@"<> x <> "> " end
      )
    }
    |> Poison.encode()
  IO.inspect HTTPoison.post(@url, thread_payload, @headers)
  end

end
