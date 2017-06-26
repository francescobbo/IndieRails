require 'resolv'

class Subscriber < ApplicationRecord
  KNOWN_DOMAINS = ['google.com', 'outlook.com', 'hotmail.com', 'yahoo.com']

  validates :name, :email, presence: true
  validates :email, uniqueness: true, format: /.+@.+/
  validate :mx_record, on: :create

  before_validation :downcase_email

  def downcase_email
    self.email = email.downcase
  end

  def mx_record
    domain = email.split('@')[1]
    if domain
      return if domain.in?(KNOWN_DOMAINS)

      mx = Resolv::DNS.open do |dns|
        dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
      end

      errors.add(:email, :invalid) unless mx.any?
    end
  end
end
