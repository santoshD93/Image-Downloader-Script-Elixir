# Getsafe

# Image Downloader Script Documentation

Introduction
The Image Downloader script is an Elixir-based command-line tool designed to download images from URLs specified in a plain text file. The script performs URL validation, image downloading, and provides informative error handling for unsupported or malformed URLs.

Usage
To use the Image Downloader script, execute it from the command line with the following syntax:

```bash
mix run download_images.exs --input INPUT_FILE --output OUTPUT_DIR
```

- INPUT_FILE: The path to the plain text file containing image URLs separated by whitespace.
- OUTPUT_DIR: The directory where downloaded images will be saved.
- For example: 
```bash
mix run download_images.exs --input input.txt --output output_images
```

Run tests

```bash
mix test test/image_downloader_test.exs
```
# Solution Explanation
The Image Downloader script is composed of the following components:

## 1. ImageDownloader Module:

- Responsible for downloading images from valid URLs and saving them to the specified output directory.
- Utilizes the HTTPoison library for making HTTP requests and the Logger module for logging.
- Implements URL validation to ensure that only supported and well-formed URLs are processed.
- Logs both successful downloads and errors with specific error messages.

## 2. CLI Module:

- Handles the command-line interface, parsing command line arguments, and invoking the appropriate functions from the ImageDownloader module.

# Workflow

1. The script reads the input plain text file using the `File.stream!/1` function.
2. The `Stream.flat_map/2` function splits the content of the file into individual URLs based on whitespace.
3. The `filter_valid_urls` function uses Enum.reduce/3 to iterate over the stream of URLs. Inside the reduce function, each URL is passed to `validate_and_normalize_url/1` for validation and normalization. If a URL is valid, it's added to the accumulator; otherwise, it's skipped. The `validate_and_normalize_url/1` function checks if the URL is well-formed and has a valid scheme (http or https). If it is valid, the URL is returned or else an error message along with the original URL are returned.
4. The `Task.async_stream/3` function processes the valid URLs concurrently. It creates tasks for each URL using the `download_image/2` function, passing the output directory as an argument. The max_concurrency option limits the number of concurrent tasks to 20.
5. The `Stream.run()` function starts the asynchronous tasks created by Task.async_stream/3 and waits for them to complete. This step ensures that all image downloads are performed before the function exits.
6. The `download_images/2` function thus orchestrates the entire process of reading the input file, validating and normalizing URLs, and asynchronously downloading images using concurrent tasks while controlling the concurrency level.

# Advantages of this Solution

## 1. Comprehensive Error Handling:

- The solution offers robust error handling for various scenarios, including invalid or unsupported URLs, failed downloads, and HTTP errors.
- Error messages include specific details about the nature of the problem, including the problematic URL.

## 2. URL Validation:

- URLs are validated using the URI module, ensuring that only URLs with valid schemes (http or https) and proper formatting are processed.

## 3. Informative Logging:

- The Logger module is used to provide detailed logging of download success, HTTP errors, and invalid URL formats.
- Users and developers can easily identify the URLs that caused issues and the nature of the problem.

## 4. Modularity:

- The solution maintains a modular structure, separating concerns for downloading images and handling the command-line interface.
- This design promotes code readability, maintainability, and potential reuse.

## 5. Concurrency for Efficient Processing:

- The solution employs concurrent tasks to download images from multiple URLs simultaneously.
- This concurrency enhances performance, enabling the download of a large number of images more efficiently.

## 6. Customizable URL Handling:

- The solution can be extended to handle additional URL formats or requirements as needed.

## 7.Ease of Use:

- Users can quickly download images by providing the input file and output directory as command-line arguments.

# Conclusion
The Image Downloader script offers a robust and user-friendly solution for downloading images from plain text files containing whitespace-separated URLs. Its comprehensive error handling, URL validation, informative logging, modularity, and concurrency features make it an effective tool for image downloading tasks. By leveraging Elixir's capabilities and libraries, the script provides a reliable and adaptable solution for users and developers alike, delivering both high performance and ease of use.

---

This comprehensive documentation explains the purpose, structure, workflow, advantages, and conclusions of the Image Downloader solution. It highlights the reasons why the chosen approach is well-suited for the given task and how it addresses the specific requirements and potential challenges.