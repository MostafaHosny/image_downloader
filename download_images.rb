require_relative './image_downloader'

file_path = ARGV[0]
save_dir = ARGV[1]

if file_path.nil? || save_dir.nil?
  puts "Usage: ruby download_images.rb /path_to_urls_file /path_to_download_directory"
  exit
end

image_downloader = ImageDownloader.new(file_path, save_dir)
image_downloader.download
