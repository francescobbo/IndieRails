class WebmentionManager
  def initialize(post)
    @client = WebmentionClient.new
    @post = post
    @source = post.url
  end

  def deliver
    targets.each do |link|
      response = client.deliver(@source, link)
      track_webmention(link, response)
    end
  end

  private

  def track_webmention(link, response)
    Webmention.find_or_create_by(source: @source, target: link, outbound: true) do |wm|
      wm.post = @post
      wm.status = response[:status]
      wm.status_endpoint = response[:status_endpoint]
    end
  end

  def targets
    (existing_targets | external_links | [@post.reply_to]).compact
  end

  def existing_targets
    Webmention.where(source: @source, outbound: true).pluck(:target)
  end

  def external_links
    LinkScraper.scrape(@post.rendered_body)
  end
end
