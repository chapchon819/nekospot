class Spot < ApplicationRecord
  acts_as_mappable default_units: :kms,
                   default_formula: :sphere,
                   distance_field_name: :distance,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  has_many :spot_images, dependent: :destroy
  belongs_to :category
  belongs_to :prefecture, class_name: 'Prefecture', foreign_key: 'prefecture_id', optional: true
  validates :name, :latitude, :longitude, :place_id, presence: true, uniqueness: true

  geocoded_by :name
  after_validation :geocode

  def closest_spot(latitude, longitude)
      target_location = Geokit::LatLng.new(latitude, longitude)
      closest_spots = Spots.where.not(id: self.id).closest(origin: target_location, units: :kms, within: 10).first
      closest_spots
  end
end
