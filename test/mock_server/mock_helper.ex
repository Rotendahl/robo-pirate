defmodule RoboPirateTest.MockSlackHelper do
  @moduledoc """
    Helper functions for the mock server
  """
  @sign_secret Application.get_env(:robo_pirate, :sign_secret)
  alias Plug.Conn

  def add_slack_headers(conn) do
    timestamp = System.system_time(:second) |> Integer.to_string()
    body = conn.body_params |> Poison.encode!()
    {:ok, body, _conn} = Conn.read_body(conn)

    signature =
      :crypto.hmac(:sha256, @sign_secret, "v0:#{timestamp}:#{body}")
      |> Base.encode16()
      |> String.downcase()

    conn
    |> Conn.put_req_header("x-slack-request-timestamp", timestamp)
    |> Conn.put_req_header("x-slack-signature", "v0=#{signature}")
    |> Conn.put_req_header("content-type", "application/json")
  end
end
