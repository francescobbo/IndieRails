class Post < ApplicationRecord
  extend FriendlyId

  enum kind: %i[note article reply rsvp photo like checkin event bookmark repost jam video scrobble review collection
                venue read comics audio exercise food quotation recipe chicken]

  friendly_id :title, use: :slugged

  validates :kind, presence: true
  validates :title, presence: true, if: -> { kind == 'article' }
  validates :body, presence: true, if: -> { kind.in?(%w[article note]) }

  scope :published, -> { where(deleted: false) }

  def body=(value)
    if value
      renderer = Redcarpet::Render::HTML.new({})
      markdown = Redcarpet::Markdown.new(renderer, autolink: true, fenced_code_blocks: true)

      self[:rendered_body] = markdown.render(value)
    end

    self[:body] = value
  end
end
