class AttachmentFile < ApplicationRecord
  mount_uploader :file, AttachmentFileUploader

  validates :original_filename, length: {maximum: 63}
end
