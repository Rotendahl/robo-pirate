defmodule RoboPirate do
  use Application

  def start(_type, _args) do
    IO.inspect "PORT IS"
    IO.inspect Application.get_env(:robo_pirate, :port)
    children = [
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: RoboPirate.Router,
        options: [port: Application.get_env(:robo_pirate, :port)]
      )
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
