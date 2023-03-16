# frozen_string_literal: true

require 'rspec'
require 'tempfile'
require_relative './image_downloader'

RSpec.describe ImageDownloader do
  let(:tmp_dir) { Dir.mktmpdir }
  after { FileUtils.remove_dir(tmp_dir) }

  describe 'download' do
    let(:file_path) do
      file = Tempfile.new
      file.write(urls)
      file.close
      file.path
    end
    subject { ImageDownloader.new(file_path, tmp_dir) }

    context 'when the file urls are valid' do
      let(:urls) { 'https://me.com/image1.jpg https://you.com/image2.jpg' }

      it 'downloads the images in the provided dirctory' do
        subject.download

        expect(File.exist?(File.join(tmp_dir, 'image1.jpg'))).to be_truthy
        expect(File.exist?(File.join(tmp_dir, 'image2.jpg'))).to be_truthy
      end

      it 'logs the downloaded urls' do
        urls_list = urls.split
        expect { subject.download }.to output(/url: #{urls_list.first} Downloaded/).to_stdout
        expect { subject.download }.to output(/url: #{urls_list.last} Downloaded/).to_stdout
      end
    end

    context 'when some urls are invalid' do
      let(:urls) { 'invalid_url/mage1.jpg https://example.com/image.jpg' }
      let(:invalid_url) { urls.split.first }
      let(:valid_url) { urls.split.last }

      it 'logs invalid download url' do
        expect { subject.download }.to output(/Failed to download: #{invalid_url}, Error: /).to_stdout
      end

      it 'downloads the valid url' do
        subject.download
        expect(File.exist?(File.join(tmp_dir, valid_url.split('/').last))).to be_truthy
      end
    end
  end
end
