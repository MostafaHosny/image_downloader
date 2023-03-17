# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'pry'
# The ImageDownloader class is responsible for downloading images from URLs and saving them to a local directory.
# It accepts a file path containing URLs of images to download, and a directory path to save the downloaded images.
# To use the ImageDownloader class, create a new instance with a file path and a save directory path, and call the
# `download` method.
class ImageDownloader
  def initialize(file_path, save_dir = Dir.pwd)
    @file_path = file_path
    @save_dir = save_dir
  end

  def download
    urls.each do |url|
      download_image(url)
    end
  end

  private

  def urls
    file = File.open(@file_path).read
    file.split
  end

  def download_image(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)

    #binding.pry

    if response.is_a?(Net::HTTPSuccess)
      save_image(response, uri.path.split('/').last)
      puts "url: #{url} Downloaded"
    else
      puts "Error: #{url} Failed to download"
    end
  rescue => e
    puts "Error: #{e}"
  end

  def save_image(response, image_name)
    File.open(File.join(@save_dir, image_name), 'wb') do |file|
      file.write(response.body)
    end
  end
end
