defmodule RoboPirateTest.MockSlackServer do
  @moduledoc """
  A mock server used for testing purposes. It should validate the input on
  all json and give either a succes or faliure error code
  """
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Poison
  )

  plug(:match)
  plug(:dispatch)

  post "chat.postMessage" do
    body = conn.body_params
    headers = conn.req_headers |> Map.new()

    cond do
      headers["authorization"] !=
          "Bearer " <> Application.get_env(:robo_pirate, :bot_token) ->
        failure(conn, "Invalid bearer token")

      headers["content-type"] != "application/json" ->
        failure(conn, "Non json content type")

      not Map.has_key?(body, "text") ->
        failure(conn, "No text field")

      not Map.has_key?(body, "channel") ->
        failure(conn, "No channel")

      true ->
        success(conn, body)
    end
  end

  match _ do
    send_resp(conn, 500, "error")
  end

  defp success(conn, body) do
    conn
    |> Plug.Conn.send_resp(200, Poison.encode!(body))
  end

  defp failure(conn, reason) do
    conn
    |> Plug.Conn.send_resp(422, Poison.encode!(%{message: "Reson: #{reason}"}))
  end
end
