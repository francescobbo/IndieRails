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

  belongs_to :post

  scope :inbound, -> { where(outbound: false) }
  scope :outbound, -> { where(outbound: true) }

  validates :source, :target, presence: true, format: /\A#{URI.regexp(%w[http https])}\z/
  validates :outbound, inclusion: { in: [true, false] }
  validates :post, presence: true, if: -> { outbound? }
  validate :check_source, if: -> { source.present? }
  validate :check_target, if: -> { target.present? }

  def check_source
    errors.add(:source, 'invalid domain') if outbound? != (URI.parse(source).host == 'francescoboffa.com')
  end

  def check_target
    errors.add(:target, 'invalid domain') if outbound? == (URI.parse(target).host == 'francescoboffa.com')
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
