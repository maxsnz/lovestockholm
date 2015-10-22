class TitleUploader < BaseUploader
  include HashedFilename

  version :pic do
    process resize_to_limit: [ 290, -1 ]
  end

end
