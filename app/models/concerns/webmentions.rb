module Webmentions
  extend ActiveSupport::Concern

  included do
    has_many :webmentions
    has_many :likes, -> { inbound.like }, class_name: 'Webmention'

    has_many :inbound_webmentions, -> { inbound }, class_name: 'Webmention', foreign_key: :post_id
    has_many :outbound_webmentions, -> { outbound }, class_name: 'Webmention', foreign_key: :post_id

    after_save :remember_to_webmention
    after_commit :run_webmentions, if: :should_webmention?
  end

  private

  def remember_to_webmention
    @should_webmention = saved_change_to_rendered_body? || saved_change_to_deleted? && !draft?
  end

  def should_webmention?
    @should_webmention
  end

  def run_webmentions
    DeliverWebmentionsJob.perform_later(self)
  end
end
