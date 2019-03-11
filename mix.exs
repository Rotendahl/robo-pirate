defmodule RoboPirate.MixProject do
  use Mix.Project

  def project do
    [
      app: :robo_pirate,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {RoboPirate, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 4.0"},
      {:httpoison, "~> 1.5"}
    ]
  end
end
