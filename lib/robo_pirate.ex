defmodule RoboPirate do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: RoboPirate.Router,
        options: [port: 4000]
      )
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
