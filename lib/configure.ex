defmodule Mix.Tasks.Threejs.Configure do
  @moduledoc """
  Configures Three.js imports in Phoenix app.js.

  Adds Three.js import and global window assignment to assets/js/app.js.

  ## Usage

      mix threejs.configure

  ## Options

      --force    Overwrite existing imports
  """

  use Mix.Task

  @shortdoc "Configures Three.js imports in Phoenix app.js"

  def run(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        switches: [force: :boolean],
        aliases: [f: :force]
      )

    force = opts[:force] || false

    Mix.shell().info("🔧 Configuring Three.js imports in app.js...")

    update_app_js(force)
  end

  defp update_app_js(force) do
    app_js_path = Path.join(["assets", "js", "app.js"])

    if File.exists?(app_js_path) do
      content = File.read!(app_js_path)

      updated_content =
        content
        |> add_threejs_import(force)
        |> add_threejs_global(force)

      if content != updated_content do
        File.write!(app_js_path, updated_content)
        Mix.shell().info("✅ Updated app.js with Three.js imports and global assignment")
      else
        Mix.shell().info("⏭️  app.js already contains Three.js setup")
      end
    else
      Mix.shell().error("❌ assets/js/app.js not found")
      Mix.shell().info("💡 Make sure you're running this from your Phoenix project root")
    end
  end

  defp add_threejs_import(content, force) do
    import_line = ~s(import * as THREE from "../vendor/three/three.module.js";)

    cond do
      String.contains?(content, import_line) and not force ->
        content

      String.contains?(content, ~s(from "../vendor/three/three.module.js")) and not force ->
        content

      true ->
        lines = String.split(content, "\n")
        {before_imports, after_imports} = find_import_insertion_point(lines)

        cleaned_lines =
          if force do
            Enum.reject(before_imports ++ after_imports, fn line ->
              String.contains?(line, "three.module.js")
            end)
          else
            before_imports ++ after_imports
          end

        {before_lines, after_lines} = find_import_insertion_point(cleaned_lines)
        updated_lines = before_lines ++ [import_line] ++ after_lines
        Enum.join(updated_lines, "\n")
    end
  end

  defp add_threejs_global(content, force) do
    global_assignment = "\n\n// Make THREE.js available globally for hooks\nwindow.THREE = THREE"

    cond do
      String.contains?(content, "window.THREE = THREE") and not force ->
        content

      String.contains?(content, "window.THREE") and not force ->
        content

      true ->
        cleaned_content =
          if force do
            content
            |> String.replace(
              ~r/\n\/\/ Make THREE\.js available globally.*\nwindow\.THREE = THREE/s,
              ""
            )
            |> String.replace(~r/window\.THREE = THREE/s, "")
          else
            content
          end

        # Find window.liveSocket assignment and add after it
        case Regex.run(~r/^.*window\.liveSocket\s*=.*$/m, cleaned_content) do
          [livesocket_line] ->
            String.replace(cleaned_content, livesocket_line, livesocket_line <> global_assignment)

          nil ->
            # Fallback: add at the end of the file
            cleaned_content <> global_assignment
        end
    end
  end

  defp find_import_insertion_point(lines) do
    last_import_index =
      lines
      |> Enum.with_index()
      |> Enum.reverse()
      |> Enum.find_value(fn {line, index} ->
        if String.match?(line, ~r/^\s*import\s+/) do
          index
        end
      end)

    case last_import_index do
      nil ->
        {[], lines}

      index ->
        {Enum.take(lines, index + 1), Enum.drop(lines, index + 1)}
    end
  end
end
