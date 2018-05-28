class Medium < ApplicationRecord
  has_attached_file :file,
                    styles: {
                      thumb: '300x300>',
                      post: '750x>',
                      large: '1200x1200>'
                    },
                    convert_options: {
                      thumb: '-quality 75 -strip'
                    },
                    processors: [:thumbnail, :paperclip_optimizer]

  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/

  before_save :extract_dimensions

  def extract_dimensions
    tempfile = file.queued_for_write[:original]
    if tempfile
      geometry = Paperclip::Geometry.from_file(tempfile)
      self.width, self.height = [geometry.width.to_i, geometry.height.to_i]
    end
  end
end
