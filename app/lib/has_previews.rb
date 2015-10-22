module HasPreviews
  extend ActiveSupport::Concern
  included do
    mount_uploader :picture, TitleUploader
    mount_uploader :picture1, OptionUploader
    mount_uploader :picture2, OptionUploader
    mount_uploader :picture3, OptionUploader
    mount_uploader :picture4, OptionUploader
    # mount_uploader :preview_hover, PreviewUploader
    # validates_presence_of :preview
  end
end
