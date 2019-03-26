defmodule RoboPirate do
  @moduledoc """
  Starts the server, if running in the test enviroment it also starts the mock
  server on the port specified in the enviroment variable
  """
  alias Plug.Adapters.Cowboy
  use Application

  def start(_type, _args) do
    children =
      [
        Cowboy.child_spec(
          scheme: :http,
          plug: RoboPirate.Router,
          options: [port: Application.get_env(:robo_pirate, :port)]
        )
      ] ++
        if Mix.env() != :test do
          []
        else
          [
            Cowboy.child_spec(
              scheme: :http,
              plug: RoboPirateTest.MockSlackServer,
              options: [port: Application.get_env(:robo_pirate, :slack_port)],
              ref: :test
            )
          ]
        end

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
