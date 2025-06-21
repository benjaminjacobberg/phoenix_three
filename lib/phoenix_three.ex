defmodule PhoenixThree do
  @moduledoc """
  Phoenix Three provides Mix tasks for managing Three.js dependencies in Phoenix projects.

  ## Installation

  Add `phoenix_three` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [
      {:phoenix_three, "~> 0.1.0", only: :dev, runtime: false}
    ]
  end
  ```

  ## Usage

  Download Three.js files and set up imports:

      mix threejs.setup

  ## Available Tasks

  - `mix threejs.setup` - Download Three.js files and configure app.js
  - `mix threejs.download` - Download Three.js files only
  - `mix threejs.configure` - Configure app.js imports only
  """

  @doc """
  Returns the current version of the PhoenixThree package.
  """
  def version, do: unquote(Mix.Project.config()[:version])
end
