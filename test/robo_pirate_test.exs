defmodule RoboPirateTest do
  use ExUnit.Case
  doctest RoboPirate

  test "greets the world" do
    assert RoboPirate.hello() == :world
  end
end
