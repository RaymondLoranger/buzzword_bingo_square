defmodule Buzzword.Bingo.Square.MixProject do
  use Mix.Project

  def project do
    [
      app: :buzzword_bingo_square,
      version: "0.1.36",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      name: "Buzzword Bingo Square",
      source_url: source_url(),
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp source_url do
    "https://github.com/RaymondLoranger/buzzword_bingo_square"
  end

  defp description do
    """
    A square struct and functions for the Multi-Player Buzzword Bingo game.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Raymond Loranger"],
      licenses: ["MIT"],
      links: %{"GitHub" => source_url()}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:buzzword_bingo_player, "~> 0.1"},
      {:buzzword_cache, "~> 0.1"},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end
end
