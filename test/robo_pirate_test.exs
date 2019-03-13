defmodule RoboPirateTest do
  use ExUnit.Case
  use Plug.Test

  alias RoboPirate.Router

  @opts Router.init([])

  test "Test / call" do
    %{resp_body: resp} = conn(:get, "/", "")
      |> Router.call(@opts)

    assert resp == "Robo pirate, has no face"
  end
end
