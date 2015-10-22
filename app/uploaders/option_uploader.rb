class OptionUploader < BaseUploader
  include HashedFilename

  version :pic do
    process resize_to_fill: [ 155, 155 ]
  end
end
