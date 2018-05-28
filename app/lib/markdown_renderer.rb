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
        MediumRenderer.render(image, class: alt_text)
      else
        ""
      end
    else
      image_tag(link, alt: alt_text, title: title)
    end
  end
end
