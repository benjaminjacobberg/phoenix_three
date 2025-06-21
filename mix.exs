defmodule PhoenixThree.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/benjaminjacobberg/phoenix_three"

  def project do
    [
      app: :phoenix_three,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      name: "Phoenix Three",
      source_url: @source_url,
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :inets, :ssl]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    A Mix task for downloading Three.js assets and setting up imports in Phoenix projects.
    Automatically downloads Three.js files from CDN and configures app.js imports.
    """
  end

  defp package do
    [
      name: "phoenix_three",
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Three.js" => "https://threejs.org"
      },
      maintainers: ["benjaminjacobberg"]
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
