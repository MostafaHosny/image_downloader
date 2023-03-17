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

    let(:http_response) { double(Net::HTTPResponse) }
    before {
      tmp_dir
      allow(Net::HTTP).to receive(:get_response).and_return(http_response)
    }

    context 'when the file urls are valid' do
      let(:urls) { 'https://me.com/image1.jpg https://you.com/image2.jpg' }
      let(:first_image) {'0_' + 'image1.jpg'}
      let(:second_image) {'1_' + 'image2.jpg'}

      before do
        allow(http_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
        allow(http_response).to receive(:body).and_return("here is data")
      end

      it 'downloads the images in the provided dirctory' do
        subject.download

        expect(File.exist?(File.join(tmp_dir, first_image))).to be_truthy
        expect(File.exist?(File.join(tmp_dir, second_image))).to be_truthy
      end

      it 'logs the downloaded urls' do
        expect { subject.download }.to output(/image: #{first_image} Downloaded/).to_stdout
        expect { subject.download }.to output(/image: #{second_image} Downloaded/).to_stdout
      end
    end

    context 'when some urls are invalid' do
      let(:urls) { 'invalid_url/mage1.jpg https://example.com/image.jpg' }
      let(:invalid_url) { urls.split.first }
      let(:valid_url) { urls.split.last }
      let(:image) {'1_' + 'image.jpg'}

      it 'logs invalid download url' do
        allow(http_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
        expect { subject.download }.to output(/Error: #{invalid_url} Failed to download/).to_stdout
      end

      it 'downloads the valid url' do
        allow(http_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
        allow(http_response).to receive(:body).and_return("here is data")

        subject.download
        expect(File.exist?(File.join(tmp_dir, image))).to be_truthy
      end
    end
    context 'when photos has same names' do
      let(:urls) { 'https://me.com/image.jpg https://you.com/image.jpg' }

      before do
        allow(http_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
        allow(http_response).to receive(:body).and_return("here is data")
      end

      it 'dose not override the old photo' do
        subject.download
        expect(Dir[File.join(tmp_dir, '*.jpg')].count).to eq(2)
      end
    end
  end
end
