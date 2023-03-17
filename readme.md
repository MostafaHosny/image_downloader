# Image Downloader

`Image Downloader` is a Ruby class that downloads images from a text file containing URLs of images and saves them to a local directory.

# Installation
```Make sure you have Ruby installed on your system```

1. Clone the repository.
2. Install Rspec gem

# Usage
1. To run the script
you would need to create a txt file that contains the urls to download.
```Bash
ruby download_images.rb  /path_to_urls.txt  /path_to_download_directory/
```
Note: if you didn't provide a download directory
the script with use the current dir by default

# Testing
To run the tests for the Image Downloader, navigate to the root directory of the repository and run
```shell
rspec image_downloader_spec.rb
```

# Some points to mention
1. The ImageDownloader class offers a straightforward and reusable solution for batch downloading images from a list of URLs.
2. To maintain simplicity and avoid overengineering, the download method is synchronous, meaning images are downloaded one by one. This approach may not be ideal for large lists of URLs.

3. In case multiple images have the same name, an index is appended to the image name to avoid overwriting. This approach offers a simple way to ensure unique filenames.
4. The ImageDownloader is implemented as a simple Ruby class, rather than a larger Rails framework, as it was not necessary for this feature. However, the script can be easily added to an existing Rails project.
