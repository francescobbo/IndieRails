class Post < ApplicationRecord
  extend FriendlyId

  enum kind: %i[note article reply rsvp photo like checkin event bookmark repost jam video scrobble review collection
                venue read comics audio exercise food quotation recipe chicken]

  validates :kind, presence: true
  friendly_id :title, use: :slugged

  def body=(value)
    renderer = Redcarpet::Render::HTML.new({})
    markdown = Redcarpet::Markdown.new(renderer)

    self[:rendered_body] = markdown.render(value)
    self[:body] = value
  end
end
