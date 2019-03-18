defmodule RoboPirate do
  alias Plug.Adapters.Cowboy
  use Application

  def start(_type, _args) do
    {port, _} = Integer.parse(Application.get_env(:robo_pirate, :port))

    children = [
      Cowboy.child_spec(
        scheme: :http,
        plug: RoboPirate.Router,
        options: [port: port]
      )
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
