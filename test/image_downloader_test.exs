defmodule ImageDownloaderTest do
  use ExUnit.Case
  import ExUnit.CaptureLog

  alias Getsafe.ImageDownloader

  @output_dir "test/assets/output_images"

  test "downloads images from URLs in input file" do
    input_file = "test/assets/input_urls.txt"

    File.write!(
      input_file,
      "https://via.placeholder.com/300.png\nhttps://via.placeholder.com/400.png"
    )

    ImageDownloader.download_images(input_file, @output_dir)

    assert File.exists?("#{@output_dir}/300.png")
    assert File.exists?("#{@output_dir}/400.png")
  end

  test "handles invalid URLs" do
    input_file = "test/assets/invalid_urls.txt"
    File.write!(input_file, "invalid_url\nftp://example.com/image.jpg")

    fun = fn ->
      ImageDownloader.download_images(input_file, @output_dir)
    end

    # Check if errors were logged properly
    assert capture_log(fun) =~
             "This URL that you provided is either invalid or has an unsupported format."
  end
end
