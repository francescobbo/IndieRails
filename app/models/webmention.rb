class Webmention < ApplicationRecord
  # Finite state machine
  #   created: the webmention has been received but it's pending verification
  #   accepted: the webmention has been verified and it's pending manual publication (optional)
  #   published: the webmention has been manually/automatically published on the referred page
  #   rejected: the webmention has been rejected. Can be for many reasons (spam, no actual mention, human hate!)
  #   removed: the webmention has been accepted in the past, but has been removed since it's not valid anymore
  #   unsupported: (only for outbounds) the target does not support webmentions/pingbacks
  # It can work for sent webmentions too.
  enum status: [:created, :accepted, :published, :rejected, :removed, :unsupported]

  scope :inbound, -> { where(outbound: false) }
  scope :outbound, -> { where(outbound: true) }

  validates :source, :target, presence: true, format: /\A#{URI.regexp(%w(http https))}\z/
  validates :outbound, inclusion: { in: [true, false] }
  validate :check_domains, if: -> { source.present? && target.present? }

  def check_domains
    if outbound?
      errors.add(:source, "invalid domain") if URI.parse(source).host != 'francescoboffa.com'
      errors.add(:target, "invalid domain") if URI.parse(target).host == 'francescoboffa.com'
    else
      errors.add(:source, "invalid domain") if URI.parse(source).host == 'francescoboffa.com'
      errors.add(:target, "invalid domain") if URI.parse(target).host != 'francescoboffa.com'
    end
  end
end
