defmodule Getsafe.ImageDownloader do
  require Logger
  alias Path, as: PathModule

  def download_images(input_file, output_dir) do
    File.mkdir_p!(output_dir)

    File.stream!(input_file)
    |> Stream.flat_map(&String.split(&1, ~r/\s+/, trim: true))
    # normalizae and filter urls
    |> filter_valid_urls()
    # use concurrent processes to optimize the download
    |> Task.async_stream(&download_image(&1, output_dir), max_concurrency: 20)
    |> Stream.run()
  end

  defp download_image(url, output_dir) when is_binary(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        image_filename = PathModule.basename(url)
        image_path = PathModule.join(output_dir, image_filename)

        File.write!(image_path, body)
        Logger.info("Downloaded: #{image_path}")
        {:ok, image_path}

      {:ok, %HTTPoison.Response{status_code: code}} ->
        handle_error_response("Failed to download #{url}. Status code: #{code}")

      {:error, reason} ->
        handle_error_response("Error downloading #{url}: #{reason}")
    end
  end

  defp filter_valid_urls(urls) do
    Enum.reduce(urls, [], fn url, acc ->
      case validate_and_normalize_url(url) do
        {:ok, normalized_url} ->
          [normalized_url | acc]

        {:error, reason} ->
          handle_error_response("Invalid URL: '#{url}'- #{reason}")
          acc
      end
    end)
    |> Enum.reverse()
  end

  defp validate_and_normalize_url(url) do
    case URI.parse(url) do
      %URI{scheme: "http" <> _} = uri when uri.host != nil ->
        {:ok, URI.to_string(uri)}

      %URI{scheme: "https" <> _} = uri when uri.host != nil ->
        {:ok, URI.to_string(uri)}

      _ ->
        {:error,
         "This URL that you provided is either invalid or has an unsupported format. Please provide a valid URL and try again."}
    end
  end

  defp handle_error_response(message) do
    Logger.error(message)
    {:error, message}
  end
end
