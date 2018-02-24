class Post < ApplicationRecord
  extend FriendlyId

  include Crawlable, Webmentions

  # enum kind: %i[note article reply rsvp like checkin event bookmark repost jam video scrobble review collection
  #               venue read comics audio exercise food quotation recipe chicken]

  friendly_id :title, use: [:SimpleI18n, :slugged]

  belongs_to :main_medium, optional: true, class_name: 'Medium'
  accepts_nested_attributes_for :main_medium

  scope :published, -> { where(draft: false, deleted: false) }

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
    if I18n.locale == :it
      self[:meta_description_it].presence || ActionController::Base.helpers.truncate(text_body_it, separator: ' ', omission: ' ', length: 150)
    else
      self[:meta_description].presence || ActionController::Base.helpers.truncate(text_body, separator: ' ', omission: ' ', length: 150)
    end
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

  def url
    Rails.application.routes.url_helpers.post_url(nil, self)
  end
end
