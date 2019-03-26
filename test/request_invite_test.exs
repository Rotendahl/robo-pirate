defmodule RoboPirateTest.RequestInviteTest do
  use ExUnit.Case
  use Plug.Test

  alias RoboPirate.Router
  @opts Router.init([])

  test "Call /invite" do
    %{resp_body: raw_body} =
      conn(:post, "/invite", "")
      |> Router.call(@opts)

    assert raw_body == File.read("lib/html/error.html") |> elem(1)
  end
end
