defmodule RoboPirate do
  use Application

  def start(_type, _args) do
    IO.inspect "PORT IS"
    {port, _} = Integer.parse(Application.get_env(:robo_pirate, :port))
    children = [
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: RoboPirate.Router,
        options: [port: port]
      )
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
