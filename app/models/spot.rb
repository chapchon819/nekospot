class Spot < ApplicationRecord
  acts_as_mappable default_units: :kms,
                   default_formula: :sphere,
                   distance_field_name: :distance,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  has_many :spot_images, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :spot_bookmarks, dependent: :destroy
  belongs_to :category
  belongs_to :prefecture, class_name: 'Prefecture', foreign_key: 'prefecture_id', optional: true
  validates :name, :latitude, :longitude, :place_id, presence: true, uniqueness: true

  # Geocoding setup
  geocoded_by :address  # 使用する地名解決にはaddress属性を利用（ここはモデルの実際の属性に依存します）
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  def self.ransackable_attributes(auth_object = nil)
    ["address", "category_id", "created_at", "id", "latitude", "longitude", "name", "opening_hours", "phone_number", "place_id", "postal_code", "prefecture_id", "rating", "updated_at", "web_site"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "prefecture", "spot_images"]
  end


  def closest_spot(latitude, longitude)
      target_location = Geokit::LatLng.new(latitude, longitude)
      closest_spots = Spots.where.not(id: self.id).closest(origin: target_location, units: :kms, within: 10).first
      closest_spots
  end
end
