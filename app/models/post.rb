class Post < ApplicationRecord
  extend FriendlyId

  # enum kind: %i[note article reply rsvp like checkin event bookmark repost jam video scrobble review collection
  #               venue read comics audio exercise food quotation recipe chicken]

  friendly_id :title, use: [:SimpleI18n, :slugged]

  has_many :webmentions
  has_many :likes, -> { like }, class_name: 'Webmention'
  belongs_to :main_medium, optional: true, class_name: 'Medium'
  accepts_nested_attributes_for :main_medium

  has_many :inbound_webmentions, -> { inbound }, class_name: 'Webmention', foreign_key: :post_id
  has_many :outbound_webmentions, -> { outbound }, class_name: 'Webmention', foreign_key: :post_id

  scope :published, -> { where(draft: false, deleted: false) }

  after_save :queue_webmentions_job, if: -> { saved_changes[:rendered_body] || saved_changes[:deleted] || saved_changes[:draft] }
  after_save :queue_scrapers_ping, if: -> { !draft? && !deleted? }

  def title
    I18n.locale == :it ? title_it : super
  end

  def title_it=(value)
    set_friendly_id(value, :it)
    super(value)
  end

  def article?
    type == 'Article'
  end

  def note?
    type == 'Note'
  end

  def reply?
    type == 'Reply'
  end

  def like?
    type == 'Like'
  end

  def photo?
    note? && main_medium
  end

  def body=(value)
    if value
      markdown = Redcarpet::Markdown.new(MarkdownRenderer.new, autolink: true, fenced_code_blocks: true)

      self[:rendered_body] = markdown.render(value)
    end

    self[:body] = value
  end

  def body_it=(value)
    if value
      markdown = Redcarpet::Markdown.new(MarkdownRenderer.new, autolink: true, fenced_code_blocks: true)

      self[:rendered_body_it] = markdown.render(value)
    end

    self[:body_it] = value
  end

  def text_body
    ActionController::Base.helpers.strip_tags(rendered_body)
  end

  def text_body_it
    ActionController::Base.helpers.strip_tags(rendered_body_it)
  end

  def meta_description
    self[:meta_description].presence || ActionController::Base.helpers.truncate(text_body, separator: ' ', omission: ' ', length: 150)
  end

  def meta_description_it
    self[:meta_description_it].presence || ActionController::Base.helpers.truncate(text_body_it, separator: ' ', omission: ' ', length: 150)
  end

  def body
    I18n.locale == :it ? body_it : super
  end

  def rendered_body
    I18n.locale == :it ? rendered_body_it : super
  end

  def draft=(value)
    self[:draft] = value
    self[:published_at] ||= Time.now.utc unless value
    value
  end

  def published?
    !draft? && !deleted?
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
      response = begin
                   client.deliver(source, link)
                 rescue
                   nil
                 end

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
