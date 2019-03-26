defmodule RoboPirate.RequestInvite do
  @invite_channel Application.get_env(:robo_pirate, :invite_channel)

  def encode_payload(%{
        "email" => mail,
        "info" => info,
        "name" => name,
        "type" => type
      }) do
    %{
      channel: @invite_channel,
      text: "#{name}, vil gerne have en invitaion til slack",
      blocks: [
        %{
          type: "section",
          text: %{
            type: "mrkdwn",
            text: "*Ohøj!* der er en ny pirat der gerne vil om bord på skuden!"
          }
        },
        %{
          type: "divider"
        },
        %{
          type: "section",
          fields: [
            %{
              type: "mrkdwn",
              text: "*Navn:*\n#{name}"
            },
            %{
              type: "mrkdwn",
              text: "*Mail:*\n#{mail}"
            },
            %{
              type: "mrkdwn",
              text: "*Type:*\n#{type}"
            },
            %{
              type: "mrkdwn",
              text: "*Info:*\n#{info}"
            }
          ]
        },
        %{
          type: "divider"
        },
        %{
          type: "actions",
          elements: [
            %{
              type: "button",
              value: "invite",
              action_id: "send_invite",
              text: %{
                type: "plain_text",
                emoji: true,
                text: "Send invitation"
              }
            },
            %{
              type: "button",
              value: "invite",
              action_id: "deny_invite",
              text: %{
                type: "plain_text",
                emoji: true,
                text: "Afvis"
              }
            }
          ]
        }
      ]
    }
    |> Poison.encode()
  end

  def encode_payload(_) do
    {:error, "Invalid payload"}
  end
end
