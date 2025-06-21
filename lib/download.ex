defmodule Mix.Tasks.Threejs.Download do
  @moduledoc """
  Downloads Three.js files from CDN.

  ## Usage

      mix threejs.download

  ## Options

      --version VERSION    Specify Three.js version (default: 0.177.0)
      --force             Overwrite existing files
  """

  use Mix.Task

  @shortdoc "Downloads Three.js files from CDN to assets/vendor/three"

  @default_version "0.177.0"
  @base_url "https://cdnjs.cloudflare.com/ajax/libs/three.js"

  @files [
    "three.tsl.js",
    "three.core.js",
    "three.module.js",
    "three.webgpu.js",
    "three.webgpu.nodes.js"
  ]

  def run(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        switches: [version: :string, force: :boolean],
        aliases: [v: :version, f: :force]
      )

    version = opts[:version] || @default_version
    force = opts[:force] || false

    target_dir = Path.join(["assets", "vendor", "three"])

    Mix.shell().info("📦 Downloading Three.js v#{version} files...")
    Mix.shell().info("📁 Target directory: #{target_dir}")

    File.mkdir_p!(target_dir)

    {:ok, _} = Application.ensure_all_started(:inets)
    {:ok, _} = Application.ensure_all_started(:ssl)

    results =
      Enum.map(@files, fn filename ->
        download_file(version, filename, target_dir, force)
      end)

    {success_count, error_count} =
      Enum.reduce(results, {0, 0}, fn
        {:ok, _}, {s, e} -> {s + 1, e}
        {:error, _}, {s, e} -> {s, e + 1}
      end)

    Mix.shell().info("\n✅ Download complete!")
    Mix.shell().info("📊 #{success_count} files downloaded successfully")

    if error_count > 0 do
      Mix.shell().error("❌ #{error_count} files failed to download")
    end
  end

  defp download_file(version, filename, target_dir, force) do
    url = "#{@base_url}/#{version}/#{filename}"
    target_path = Path.join(target_dir, filename)

    if File.exists?(target_path) and not force do
      Mix.shell().info("⏭️  Skipping #{filename} (already exists, use --force to overwrite)")
      {:ok, :skipped}
    else
      Mix.shell().info("📥 Downloading #{filename}...")

      case download_with_httpc(url) do
        {:ok, content} ->
          File.write!(target_path, content)
          file_size = byte_size(content) |> format_bytes()
          Mix.shell().info("✅ #{filename} (#{file_size})")
          {:ok, :downloaded}

        {:error, reason} ->
          Mix.shell().error("❌ Failed to download #{filename}: #{inspect(reason)}")
          {:error, reason}
      end
    end
  end

  defp download_with_httpc(url) do
    url_charlist = String.to_charlist(url)

    case :httpc.request(:get, {url_charlist, []}, [{:timeout, 30_000}], []) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        {:ok, List.to_string(body)}

      {:ok, {{_, status_code, _}, _headers, _body}} ->
        {:error, "HTTP #{status_code}"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp format_bytes(bytes) when bytes < 1024, do: "#{bytes} B"
  defp format_bytes(bytes) when bytes < 1024 * 1024, do: "#{Float.round(bytes / 1024, 1)} KB"
  defp format_bytes(bytes), do: "#{Float.round(bytes / (1024 * 1024), 1)} MB"
end
