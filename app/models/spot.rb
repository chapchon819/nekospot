class Spot < ApplicationRecord
  acts_as_mappable default_units: :kms,
                   default_formula: :sphere,
                   distance_field_name: :distance,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  enum foster_parents: { no_recruitment: 0, recruitment: 1 }
  enum adoption_event: { unheld: 0, held: 1 }
  enum age_limit: { no_listed: 0, unlimited: 1, walking_age: 2, three_and_above: 3, six_and_above: 6, middle_school_and_above: 12 }

  has_many :spot_images, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :spot_bookmarks, dependent: :destroy
  belongs_to :category
  belongs_to :prefecture, class_name: 'Prefecture', foreign_key: 'prefecture_id', optional: true
  validates :name, :latitude, :longitude, :place_id, presence: true, uniqueness: true  
  
  #enumの日本語化
  def foster_parents_i18n
    I18n.t("activerecord.attributes.spot.foster_parents.#{foster_parents}")
  end

  def adoption_event_i18n
    I18n.t("activerecord.attributes.spot.adoption_event.#{adoption_event}")
  end

  def age_limit_i18n
    I18n.t("activerecord.attributes.spot.age_limit.#{age_limit}")
  end



  # 猫の画像を優先的に表示させるメソッド
  def prioritized_spot_image #SpotImageの中で、cat属性がtrueのものを優先的に取得し、存在しない場合は最初のSpotImageを取得する
    spot_images.find_by(cat: true) || spot_images.first
  end

  # Geocoding setup
  geocoded_by :address  # 使用する地名解決にはaddress属性を利用（ここはモデルの実際の属性に依存）
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
