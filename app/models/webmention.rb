class Webmention < ApplicationRecord
  # Finite state machine
  #   created: the webmention has been received but it's pending verification
  #   accepted: the webmention has been verified and it's pending manual publication (optional)
  #   published: the webmention has been manually/automatically published on the referred page
  #   rejected: the webmention has been rejected. Can be for many reasons (spam, no actual mention, human hate!)
  #   removed: the webmention has been accepted in the past, but has been removed since it's not valid anymore
  #   unsupported: (only for outbounds) the target does not support webmentions/pingbacks
  # It can work for sent webmentions too.
  enum status: %i[created accepted published rejected removed unsupported]
  enum kind: %i[link like reply]

  belongs_to :post, optional: true

  scope :inbound, -> { where(outbound: false) }
  scope :outbound, -> { where(outbound: true) }

  validates :source, :target, presence: true, format: /\A#{URI.regexp(%w[http https])}\z/
  validates :outbound, inclusion: { in: [true, false] }
  validates :post, presence: true, if: -> { outbound? }
  validate :check_source, if: -> { source.present? }
  validate :check_target, if: -> { target.present? }

  before_create :check_acceptable_target, if: -> { inbound? }
  after_create :enqueue_webmention_check, if: -> { inbound? }

  def check_source
    errors.add(:source, 'invalid domain') if outbound? != (URI.parse(source).host == 'francescoboffa.com')
  end

  def check_target
    errors.add(:target, 'invalid domain') if outbound? == (URI.parse(target).host == 'francescoboffa.com')
  end

  def inbound?
    !outbound?
  end

  def check_acceptable_target
    route = Rails.application.routes.recognize_path(target)

    self.post = Post.find(route[:id]) if route[:controller] == 'posts' && route[:action] == 'show'

  rescue ActiveRecord::RecordNotFound
    errors.add(:target, 'invalid target URL')
  end

  def enqueue_webmention_check
    CheckWebmentionJob.perform_later(self)
  end

  def check_webmention
    document = Nokogiri::HTML(WebmentionClient.new.fetch(source)[0].body)

    candidate_links = document.css('.h-entry a[href]').select { |link| link[:href] == target }
    if candidate_links.any?
      # There's an actual link!

      liked_links = document.css('.h-entry a.u-like-of[href], .h-entry .u-like-of a.u-url[href]')
      if liked_links.any? { |link| link[:href] == target }
        self.kind = :like
      end

      self.status = :accepted
    else
      if status.in?['accepted', 'published']
        # We verified this mention before and we cannot find it anymore
        self.status = :removed
      else
        # This looks pretty much like SPAM
        self.status = :rejected
      end
    end

  rescue StandardError
    # Something went wrong
    self.status = :rejected
  ensure
    save
  end

  RESPONSES = {
    created: { plain: 'The webmention is pending verification', status: :created },
    accepted: { plain: 'The webmention has been verified and is pending manual approval', status: :created },
    published: { plain: 'The webmention has been approved and may be visible on the mentioned page' },
    rejected: { plain: 'The webmention has been rejected', status: :unprocessable_entity },
    removed: { plain: 'The webmention has been removed due to source content expiration', status: :gone }
  }.freeze

  def status_response
    RESPONSES[status.to_sym]
  end
end
