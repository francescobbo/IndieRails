class MediumRenderer
  class << self
    include ActionView::Helpers::AssetTagHelper

    def render(medium, img_attributes = {})
      webp_source = tag.source(type: 'image/webp', srcset: srcset(medium, format: :webp), sizes: sizes)
      default_source = tag.source(srcset: srcset(medium), sizes: sizes)

      fallback_image = image_tag(medium.file.url(:post), {
        alt: medium.default_alt,
        srcset: srcset(medium),
        sizes: sizes
      }.merge(img_attributes))

      tag.picture(webp_source + default_source + fallback_image)
    end

    def srcset(medium, format: nil)
      suffix = format ? "_#{format}" : ''
      images = {
        medium.file.url(:"thumb#{suffix}") => '300w',
        medium.file.url(:"post#{suffix}") => '750w',
        medium.file.url(:"large#{suffix}") => '1200w',
      }

      images.map { |src, size| "#{src} #{size}" }.join(', ')
    end

    def sizes
      '(min-width: 782px) 750px, 100vw'
    end
  end
end
