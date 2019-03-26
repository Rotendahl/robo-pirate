defmodule RoboPirateTest do
  use ExUnit.Case
  use Plug.Test

  alias RoboPirate.Router
  @opts Router.init([])

  test "Test get root / call" do
    %{resp_body: resp} =
      conn(:get, "/", "")
      |> Router.call(@opts)

    assert resp == File.read("lib/html/index.html") |> elem(1)
  end

  test "Test event not from slack" do
    %{status: deny, resp_body: resp} =
      conn(:post, "/event", %{})
      |> Router.call(@opts)

    assert resp == "Only slack can issue events"
    assert deny == 401
  end

  test "Test action not from slack" do
    %{status: deny, resp_body: resp} =
      conn(:post, "/action", %{Hello: "world"})
      |> Router.call(@opts)

    assert resp == "Only slack can issue actions"
    assert deny == 401
  end
end
