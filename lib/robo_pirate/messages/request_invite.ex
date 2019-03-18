defmodule RoboPirate.RequestInvite do
  @invite_channel Application.get_env(:robo_pirate, :invite_channel)

  def payload(%{"email" => mail, "info" => info, "name" => name, "type" => type}) do
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
              text: %{
                type: "plain_text",
                emoji: true,
                text: "Send invitation"
              },
              value: "invite"
            },
            %{
              type: "button",
              text: %{
                type: "plain_text",
                emoji: true,
                text: "Afvis"
              },
              value: "reject"
            }
          ]
        }
      ]
    }
    |> Poison.encode()
  end
end
