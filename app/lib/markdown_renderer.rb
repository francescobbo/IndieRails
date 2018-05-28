require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

class MarkdownRenderer < Redcarpet::Render::HTML
  include ActionView::Helpers::AssetTagHelper
  include Rouge::Plugins::Redcarpet

  def image(link, alt_text, title)
    if title =~ /\A[a-f0-9-]{36}\z/i
      image = Medium.where(id: title).first
      if image
        webp_source = tag.source(type: 'image/webp', srcset: srcset(image, format: :webp))
        default_source = tag.source(srcset: srcset(image))
        fallback_image = image_tag(image.file.url(:post), alt: image.default_alt, class: alt_text)

        tag.picture(webp_source + default_source + fallback_image)
      else
        ""
      end
    else
      image_tag(link, alt: alt_text, title: title)
    end
  end

  private

  def srcset(image, format: nil)
    suffix = format ? "_#{format}" : ''
    images = {
      image.file.url(:"thumb#{suffix}") => '300w',
      image.file.url(:"post#{suffix}") => '750w',
      image.file.url(:"large#{suffix}") => '1200w',
    }

    images.map { |src, size| "#{path_to_image(src)} #{size}" }.join(', ')
  end
end
