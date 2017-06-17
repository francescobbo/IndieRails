class Post < ApplicationRecord
  extend FriendlyId

  enum kind: %i[note article reply rsvp like checkin event bookmark repost jam video scrobble review collection
                venue read comics audio exercise food quotation recipe chicken]

  friendly_id :title, use: :slugged

  has_many :webmentions
  has_many :likes, -> { like }, class_name: 'Webmention'
  belongs_to :main_medium, optional: true, class_name: 'Medium'
  accepts_nested_attributes_for :main_medium

  validates :kind, presence: true
  validates :title, presence: true, if: -> { kind == 'article' }
  validates :body, presence: true, if: -> { kind.in?(%w[article note]) }
  validates :reply_to, presence: true, format: /\A#{URI.regexp(%w[http https])}\z/, if: -> { kind.in?(%w[reply rsvp like bookmark repost])}

  has_many :inbound_webmentions, -> { inbound }, class_name: 'Webmention', foreign_key: :post_id
  has_many :outbound_webmentions, -> { outbound }, class_name: 'Webmention', foreign_key: :post_id

  scope :published, -> { where(draft: false, deleted: false) }

  after_save :queue_webmentions_job, if: -> { saved_changes[:rendered_body] || saved_changes[:deleted] || saved_changes[:draft] }
  after_save :queue_scrapers_ping, if: -> { !draft? && !deleted? }

  def body=(value)
    if value
      markdown = Redcarpet::Markdown.new(MarkdownRenderer.new, autolink: true, fenced_code_blocks: true)

      self[:rendered_body] = markdown.render(value)
    end

    self[:body] = value
  end

  def text_body
    ActionController::Base.helpers.strip_tags(rendered_body)
  end

  def meta_description
    ActionController::Base.helpers.truncate(text_body, separator: ' ', omission: ' ', length: 150)
  end

  def draft=(value)
    self[:draft] = value
    self[:published_at] ||= Time.now.utc if value
    value
  end

  def published?
    !draft? && !deleted?
  end

  def photo?
    note? && main_medium
  end

  def queue_webmentions_job
    DeliverWebmentionsJob.perform_later(self) unless draft?
  end

  def queue_scrapers_ping
    PingCrawlersJob.perform_later
  end

  def deliver_webmentions
    client = WebmentionClient.new
    source = Rails.application.routes.url_helpers.post_url(self)

    targets = Webmention.where(source: source, outbound: true).pluck(:target) | [reply_to] | external_links
    targets.compact.each do |link|
      response = client.deliver(source, link) rescue nil

      track_webmention(source, link, response)
    end
  end

  def track_webmention(source, link, response)
    webmention = Webmention.find_or_initialize_by(source: source, target: link, outbound: true)
    webmention.post = self
    response_code = response&.code&.to_i

    if !response || !response_code.in?(200..202)
      webmention.status = :unsupported
    else
      webmention.status = response_code == 200 ? :accepted : :created
      webmention.status_endpoint = response['location'] if response_code == 201
    end

    webmention.save
  end

  def external_links
    document = Nokogiri::HTML(rendered_body)
    nodes = document.css('a[href], img[src], video[src]')

    links = nodes.map { |node| node[:href].strip.presence || node[:src].strip.presence }

    filter_links(links)
  end

  def filter_links(links)
    links.compact.reject { |link| link !~ %r{\Ahttps?://} || link =~ %r{\Ahttps?://francescoboffa.com} }
  end
end
