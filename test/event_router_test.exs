defmodule RoboPirateTest.RouterEvent do
  use ExUnit.Case
  use Plug.Test
  alias RoboPirate.Router
  alias RoboPirateTest.MockSlackHelper
  @opts Router.init([])

  test "Test event not from slack" do
    %{status: deny, resp_body: resp} =
      conn(:post, "/event", %{})
      |> Router.call(@opts)

    assert resp == "Only slack can issue events"
    assert deny == 401
  end

  test "Test unhandled event types" do
    %{status: status, resp_body: resp} =
      conn(:post, "/event", Poison.encode!(%{type: "party!"}))
      |> MockSlackHelper.add_slack_headers()
      |> Router.call(@opts)

    assert status == 400
    assert resp == "Unhandled event Type: party!"

    %{status: status, resp_body: resp} =
      conn(:post, "/event", Poison.encode!(%{}))
      |> MockSlackHelper.add_slack_headers()
      |> Router.call(@opts)

    assert status == 400
    assert resp == "No event type"
  end

  test "Test valid url verification" do
    challenge = "Some challenge"

    payload =
      %{
        token: Application.get_env(:robo_pirate, :slack_token),
        challenge: challenge,
        type: "url_verification"
      }
      |> Poison.encode!()

    %{status: status, resp_body: resp} =
      conn(:post, "/event", payload)
      |> MockSlackHelper.add_slack_headers()
      |> Router.call(@opts)

    assert status == 200
    assert resp == challenge
  end

  test "Test invalid url verification" do
    challenge = "Some challenge"

    payload =
      %{
        token: "Wrong-token",
        challenge: challenge,
        type: "url_verification"
      }
      |> Poison.encode!()

    %{status: status, resp_body: resp} =
      conn(:post, "/event", payload)
      |> MockSlackHelper.add_slack_headers()
      |> Router.call(@opts)

    assert status == 401
    assert resp == "Incorret token"
  end

  test "Event callback unhandled" do
    payload =
      %{
        event: %{},
        type: "event_callback"
      }
      |> Poison.encode!()

    %{status: status, resp_body: resp} =
      conn(:post, "/event", payload)
      |> MockSlackHelper.add_slack_headers()
      |> Router.call(@opts)

    assert status == 500
    assert resp == "Unhandled event"
  end

  test "Event callback bot mention" do
    payload =
      %{
        event: %{type: "app_mention", subtype: "bot_message"},
        type: "event_callback"
      }
      |> Poison.encode!()

    %{status: status, resp_body: resp} =
      conn(:post, "/event", payload)
      |> MockSlackHelper.add_slack_headers()
      |> Router.call(@opts)

    assert status == 200
    assert resp == "bot_message"
  end

  test "Event callback mention" do
    expected_channel = "Some channel"

    payload =
      %{
        event: %{
          type: "app_mention",
          text: "",
          channel: expected_channel,
          user: "some_User"
        },
        type: "event_callback"
      }
      |> Poison.encode!()

    %{status: status, resp_body: resp} =
      conn(:post, "/event", payload)
      |> MockSlackHelper.add_slack_headers()
      |> Router.call(@opts)

    %{"text" => text, "channel" => actual_channel} = Poison.decode!(resp)
    assert actual_channel == expected_channel
    assert text =~ "Den forstod jeg ikke"
    assert status == 200
  end

  test "Event new channel" do
    new_channel = "Some channel"
    creator = "some creator"

    payload =
      %{
        event: %{
          type: "channel_created",
          channel: %{creator: creator, id: new_channel}
        },
        type: "event_callback"
      }
      |> Poison.encode!()

    %{status: status, resp_body: resp} =
      conn(:post, "/event", payload)
      |> MockSlackHelper.add_slack_headers()
      |> Router.call(@opts)

    %{"text" => text, "channel" => announcment_channel} = Poison.decode!(resp)

    assert announcment_channel ==
             Application.get_env(:robo_pirate, :announcemnts_id)

    assert text =~ creator
    assert text =~ new_channel
    assert status == 200
  end
end
