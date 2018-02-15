module SeoConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_default_meta_tags
    helper_method :jsonld_items
  end

  protected

  def add_jsonld(data)
    jsonld_items << data
  end

  private

  def set_default_meta_tags
    set_meta_tags(
      viewport: 'width=device-width,minimum-scale=1,initial-scale=1',
      site: Settings.site_name,
      reverse: true,
      separator: '|'
    )

    add_jsonld(Seo::Website.jsonld)
  end

  def jsonld_items
    @jsonld_items ||= []
  end
end
