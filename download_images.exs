defmodule CLI do
  def run(args) do
    case args do
      ["--input", input_file, "--output", output_dir] ->
        Getsafe.ImageDownloader.download_images(input_file, output_dir)

      _ ->
        IO.puts("Usage: mix run download_images.exs --input INPUT_FILE --output OUTPUT_DIR")
    end
  end
end

CLI.run(System.argv)
