defmodule RoboPirate.Router do
  alias RoboPirate.ActionHandler
  alias RoboPirate.AuthHelper
  alias RoboPirate.EventHandler
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
    case MessageSender.request_invite(conn.params) do
      {:ok, _} -> send_file(conn, 200, "lib/html/success.html")
      {:error, _reason} -> send_file(conn, 402, "lib/html/error.html")
    end
  end

  post "/action" do
    if conn |> AuthHelper.from_slack?() do
      {:ok, payload} = conn.body_params["payload"] |> Poison.decode()
      Task.async(fn -> ActionHandler.handle_action(payload) end)
      send_resp(conn, 200, "")
    else
      send_resp(conn, 401, "Only slack can issue actions")
    end
  end

  post "/event" do
    if conn |> AuthHelper.from_slack?() do
      case conn.body_params["type"] do
        "event_callback" ->
          {status, payload} =
            case EventHandler.handle_event(conn.body_params["event"]) do
              {:ok, %HTTPoison.Response{body: body}} -> {200, body}
              {:error, error} -> {500, error}
              _unkown_error -> {500, "Unkown error"}
            end

          send_resp(conn, status, payload)

        "url_verification" ->
          %{"token" => token, "challenge" => chal} = conn.body_params

          if token == Application.get_env(:robo_pirate, :slack_token) do
            send_resp(conn, 200, chal)
          else
            send_resp(conn, 401, "Incorret token")
          end

        _unkown_event_type ->
          send_resp(conn, 500, "Unhandled event Type")
      end
    else
      send_resp(conn, 401, "Only slack can issue events")
    end
  end

  match _ do
    send_resp(conn, 404, "not_found")
  end
end
