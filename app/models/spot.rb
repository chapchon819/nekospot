class Spot < ApplicationRecord
  belongs_to :category
  belongs_to :prefecture, class_name: 'Prefecture', foreign_key: 'prefecture_id', optional: true
  geocoded_by :name
  after_validation :geocode
  validates :name, :latitude, :longitude, :place_id, presence: true, uniqueness: true
end
