class Medium < ApplicationRecord
  has_attached_file :file,
                    styles: {
                      thumb: '300x300>',
                      large: '1200x1200>',
                    },
                    convert_options: {
                      thumb: '-quality 75 -strip'
                    }

  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/
end
