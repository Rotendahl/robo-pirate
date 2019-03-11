defmodule RoboPirate.Router do
  alias RoboPirate.EventHandler
  alias RoboPirate.ActionHandler
  use Plug.Router
  use Plug.Debugger, otp_app: :robo_pirate

  plug(Plug.Logger)
  plug(Plug.Parsers, parsers: [:json, :urlencoded, :multipart], json_decoder: Poison)
  plug(:match)
  plug(:dispatch)

  get "" do
    send_resp(conn, 200, "Robo pirate, has no face")
  end

  post "/action" do
    {:ok, payload} = conn.body_params["payload"] |> Poison.decode()
    # IO.inspect(payload)
    #Task.async(fn -> ActionHandler.handle_action(payload) end)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, ActionHandler.handle_action(payload))
  end


  post "/event" do
    IO.inspect(conn.body_params)
    %{"type" => type} = conn.body_params
    params = conn.body_params
    case type do
      "url_verification" ->
        %{"token" => token, "challenge" => chal} = conn.body_params
        if token == Application.get_env(:robo_pirate, :slack_token) do
          send_resp(conn, 200, chal)
        else
          send_resp(conn, 500, "Incorret token")
        end

      "event_callback" ->
        Task.async(fn -> EventHandler.handle_event(params) end)
        send_resp(conn, 200, "")
      _ ->
        IO.inspect("Event not handled: #{type}")
        send_resp(conn, 200, "not_supported")
    end
  end

  match _ do
    IO.inspect conn
    send_resp(conn, 404, "not_found")
  end
end
