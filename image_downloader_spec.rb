# frozen_string_literal: true

require 'rspec'
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

    context 'when the urls are valid' do
      let(:urls) { 'https://me.com/image1.jpg https://you.com/image2.jpg' }
      let(:urls_count) { urls.split(' ').size }

      it 'downloads the images in the provided dirctory' do
        subject.download

        expect(File.exist?(File.join(tmp_dir, 'image1.jpg'))).to be_truthy
        expect(File.exist?(File.join(tmp_dir, 'image2.jpg'))).to be_truthy
      end
    end
  end
end
