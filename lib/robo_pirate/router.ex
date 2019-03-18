defmodule RoboPirate.Router do
  alias RoboPirate.AuthHelper
  alias RoboPirate.EventHandler
  alias RoboPirate.ActionHandler
  alias RoboPirate.MessageSender
  use Plug.Router
  use Plug.Builder
  use Plug.Debugger, otp_app: :robo_pirate

  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:json, :urlencoded, :multipart],
    json_decoder: Poison,
    body_reader: {RoboPirate.RawPlug, :read_body, []}
  )

  plug(:match)
  plug(:dispatch)

  plug(Plug.Static,
    at: "/lib/html",
    from: :robo_pirate
  )

  get "/" do
    conn = put_resp_content_type(conn, "text/html")
    send_file(conn, 200, "lib/html/index.html")
  end

  post "/invite" do
    %{body_params: params} = conn
    status_code = MessageSender.request_invite(params)

    if status_code == 200 do
      send_file(conn, status_code, "lib/html/success.html")
    else
      send_file(conn, status_code, "lib/html/error.html")
    end
  end

  post "/action" do
    if conn |> AuthHelper.from_slack? do
      {:ok, payload} = conn.body_params["payload"] |> Poison.decode()
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, ActionHandler.handle_action(payload))
    else
       send_resp(conn, 401, "Only slack can issue actions")
    end

  end

  post "/event" do
    %{"type" => type} = conn.body_params
    params = conn.body_params
    case type do
      "url_verification" ->
        %{"token" => token, "challenge" => chal} = conn.body_params

        if token == Application.get_env(:robo_pirate, :slack_token) do
          send_resp(conn, 200, chal)
        else
          send_resp(conn, 401, "Incorret token")
        end

      "event_callback" ->
        if conn |> AuthHelper.from_slack? do
          Task.async(fn -> EventHandler.handle_event(params) end)
          send_resp(conn, 200, "")
        else
           send_resp(conn, 401, "Only slack can issue actions")
        end
      _ ->
        send_resp(conn, 200, "not_supported")
    end
  end

  match _ do
    send_resp(conn, 404, "not_found")
  end
end
