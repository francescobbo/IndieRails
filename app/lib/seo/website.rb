module Seo
  class Website
    class << self
      include Rails.application.routes.url_helpers

      def jsonld
        {
          '@id': root_url,
          '@context': 'https://schema.org',
          '@type': 'WebSite',
          url: root_url,
          name: Settings.site_name,
          description: Settings.tagline
        }
      end
    end
  end
end
