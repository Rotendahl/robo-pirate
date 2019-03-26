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
end
