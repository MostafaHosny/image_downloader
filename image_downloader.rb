require 'net/http'
require 'uri'

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
    return unless File.exists?(@file_path)

    file = File.open(@file_path).read
    file.split()
  end

  def download_image(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)

    save_image(response, uri.path.split('/').last)
    puts "url: #{url} Downloaded"
  end

  def save_image(response, image_name)
    File.open(File.join(@save_dir, image_name), 'wb') do |file|
      file.write(response.body)
    end
  end
end
