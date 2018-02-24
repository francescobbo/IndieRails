class LinkScraper
  class << self
    def scrape(html)
      document = Nokogiri::HTML(html)
      nodes = document.css('a[href], img[src], video[src]')

      uris = nodes.map do |node|
        node[:href].strip.presence || node[:src].strip.presence
      end

      remove_self(keep_web uris.compact)
    end

    def remove_self(uris)
      uris.reject { |uri| uri.starts_with?(%r{https://#{Settings.host}}) }
    end

    def keep_web(uris)
      uris.select { |uri| uri.starts_with?(%r{https?://}) }
    end
  end
end
