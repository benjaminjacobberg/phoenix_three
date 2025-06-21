defmodule Mix.Tasks.Threejs.Setup do
  @moduledoc """
  Complete Three.js setup for Phoenix projects.

  Downloads Three.js files from CDN and configures app.js imports.

  ## Usage

      mix threejs.setup

  ## Options

      --version VERSION    Specify Three.js version (default: 0.177.0)
      --force             Overwrite existing files and imports
  """

  use Mix.Task

  @shortdoc "Downloads Three.js files and sets up imports in Phoenix projects"

  def run(args) do
    Mix.Task.run("threejs.download", args)
    Mix.Task.run("threejs.configure", args)
  end
end
