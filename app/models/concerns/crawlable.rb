module Crawlable
  extend ActiveSupport::Concern

  included do
    after_save :queue_scrapers_ping, if: :published?
  end

  def queue_scrapers_ping
    PingCrawlersJob.perform_later
  end
end
