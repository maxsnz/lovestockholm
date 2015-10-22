class BaseUploader < CarrierWave::Uploader::Base
  storage :ftp
  include CarrierWave::MiniMagick

  process quality: 90
  process resize_to_fit: [600, 600]

def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    paths = [
      "#{mounted_as}"
    ].compact

    File.join *paths
  end

  private

  def interpolated_id
    ("%09d" % model.id).scan(/\d{2}/).join("/")
  end
end
