defmodule RoboPirate.Actions.InviteHandler do
  alias RoboPirate.MessageSender
  @vol_channels Application.get_env(:robo_pirate, :volunteer_channels)
  @child_channels Application.get_env(:robo_pirate, :child_channels)
  @token Application.get_env(:robo_pirate, :legacy_token)

  def invite(action = %{"actions" => [%{"action_id" => decision} | _]}) do
    %{
      "channel" => %{"id" => channel},
      "message" => %{"blocks" => blocks},
      "container" => %{"message_ts" => ts},
      "user" => %{"id" => user}
    } = action

    replacement_text =
      if decision == "send_invite" do
        "✅ Invitationen er godkendt af <@#{user}>"
      else
        "❌ Invitationen er afvist af <@#{user}>"
      end

    new_section = %{
      "type" => "section",
      "text" => %{
        "text" => replacement_text,
        "type" => "mrkdwn"
      }
    }

    new_blocks =
      Enum.map(blocks, fn block = %{"type" => type} ->
        if type == "actions" do
          new_section
        else
          block
        end
      end)

    payload = %{
      ts: ts,
      channel: channel,
      text: replacement_text,
      blocks: new_blocks
    }

    if decision == "send_invite" do
      info_block =
        blocks
        |> Enum.filter(fn block -> block |> Map.has_key?("fields") end)
        |> hd

      send_invite(info_block)
    end

    MessageSender.update_message(payload)
  end

  def send_invite(%{"fields" => fields}) do
    info =
      fields
      |> Enum.map(fn %{"text" => field} ->
        cond do
          field =~ "*Navn:*\n" ->
            {:name, String.replace(field, "*Navn:*\n", "")}

          field =~ "*Mail:*\n" ->
            mail =
              field
              |> String.split("|")
              |> List.last()
              |> String.replace(">", "")

            {:mail, mail}

          field =~ "Type" ->
            {:type,
             if field =~ "frivillig" do
               "frivillig"
             else
               "barn"
             end}

          field =~ "*Info:*\n" ->
            {:info, String.replace(field, "*Info:*\n", "")}
        end
      end)
      |> Map.new()

    req_fields =
      [{:token, @token}, {:email, info[:mail]}] ++
        if info[:type] == "frivillig" do
          [{:channels, @vol_channels}]
        else
          [{:channels, @child_channels}, {:restricted, true}]
        end

    body = {:form, req_fields}

    HTTPoison.request(:post, "https://slack.com/api/users.admin.invite", body, [
      {"Content-Type", "application/x-www-form-urlencoded"}
    ])
  end
end
