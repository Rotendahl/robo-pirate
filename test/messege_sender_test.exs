defmodule RoboPirateTest.MessageTest do
  use ExUnit.Case
  alias Faker.Beer
  alias RoboPirate.MessageSender

  test "Sends a message" do
    msg = Beer.name()
    channel = Beer.brand()

    {succes, %{status_code: status, body: raw_body}} =
      MessageSender.send_message(msg, channel)

    body = Poison.decode!(raw_body)

    assert 200 == status
    assert succes == :ok
    assert msg == body["text"]
    assert channel == body["channel"]
  end
end
