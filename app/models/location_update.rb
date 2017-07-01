class LocationUpdate < ApplicationRecord
  validates :latitude, :longitude, presence: true
end
