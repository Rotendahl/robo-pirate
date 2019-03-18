defmodule RoboPirateTest do
  use ExUnit.Case
  use Plug.Test

  alias RoboPirate.Router

  @token Application.get_env(:robo_pirate, :slack_token)
  @opts Router.init([])

  test "Test get root / call" do
    %{resp_body: resp} =
      conn(:get, "/", "")
      |> Router.call(@opts)

    index = File.read("lib/html/index.html") |> elem(1)
    assert resp == index
  end

  test "Test verify url" do
    payload = %{
      type: "url_verification",
      token: @token,
      challenge: String.reverse(@token)
    }

    %{resp_body: resp, status: status} =
      conn(:post, "/event", payload)
      |> Router.call(@opts)

    assert status == 200
    assert resp == String.reverse(@token)

    %{status: deny} =
      conn(:post, "/event", Map.put(payload, :token, "a"))
      |> Router.call(@opts)

    assert deny == 401
  end
end
