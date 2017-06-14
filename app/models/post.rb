class Post < ApplicationRecord
  extend FriendlyId

  enum kind: %i[note article reply rsvp like checkin event bookmark repost jam video scrobble review collection
                venue read comics audio exercise food quotation recipe chicken]

  friendly_id :title, use: :slugged

  belongs_to :main_medium, optional: true, class_name: 'Medium'
  accepts_nested_attributes_for :main_medium

  validates :kind, presence: true
  validates :title, presence: true, if: -> { kind == 'article' }
  validates :body, presence: true, if: -> { kind.in?(%w[article note]) }

  has_many :inbound_webmentions, -> { inbound }, class_name: 'Webmention', foreign_key: :post_id
  has_many :outbound_webmentions, -> { outbound }, class_name: 'Webmention', foreign_key: :post_id

  scope :published, -> { where(deleted: false) }

  after_save :queue_webmentions_job, if: -> { saved_changes[:rendered_body] || saved_changes[:deleted] }

  def body=(value)
    if value
      markdown = Redcarpet::Markdown.new(MarkdownRenderer.new, autolink: true, fenced_code_blocks: true)

      self[:rendered_body] = markdown.render(value)
    end

    self[:body] = value
  end

  def queue_webmentions_job
    DeliverWebmentionsJob.perform_later(self)
  end

  def deliver_webmentions
    client = WebmentionClient.new
    source = Rails.application.routes.url_helpers.post_url(self)

    targets = Webmention.where(source: source, outbound: true).pluck(:target) | external_links
    targets.each do |link|
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
