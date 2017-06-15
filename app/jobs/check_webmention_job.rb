class CheckWebmentionJob < ApplicationJob
  queue_as :default

  def perform(webmention)
    webmention.check_webmention
  end
end
