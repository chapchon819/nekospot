class Spot < ApplicationRecord
  require 'open-uri'
  require 'mini_magick'
  mount_uploader :ogp_image, ProcessedImageUploader
  before_save :generate_ogp_image, if: :should_generate_ogp_image?
  
  acts_as_mappable default_units: :kms,
                   default_formula: :sphere,
                   distance_field_name: :distance,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  enum foster_parents: { no_recruitment: 0, recruitment: 1 }
  enum adoption_event: { unheld: 0, held: 1 }
  enum age_limit: { no_listed: 0, unlimited: 1, walking_age: 2, three_and_above: 3, four_and_above: 4, six_and_above: 6, ten_and_above: 10, middle_school_and_above: 12 }

  has_many :spot_images, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :spot_bookmarks, dependent: :destroy
  has_many :visits, dependent: :destroy
  belongs_to :category
  belongs_to :prefecture, class_name: 'Prefecture', foreign_key: 'prefecture_id', optional: true
  validates :name, :latitude, :longitude, :place_id, presence: true, uniqueness: true  
  
  #enumの日本語化
  def foster_parents_i18n
    I18n.t("enums.spot.foster_parents.#{foster_parents}")
  end

  def adoption_event_i18n
    I18n.t("enums.spot.adoption_event.#{adoption_event}")
  end

  def age_limit_i18n
    I18n.t("enums.spot.age_limit.#{age_limit}")
  end

  # タグに基づいたスポットをフィルタリングするスコープ
  scope :with_tag, -> (tag_name) {
    joins(reviews: :tags).where(tags: { name: tag_name }).distinct
  }

  # Ransackで検索可能なカスタムスコープを指定
  def self.ransackable_scopes(auth_object = nil)
    %i[with_tag]
  end



  # 猫の画像を優先的に表示させるメソッド
  def prioritized_spot_image #SpotImageの中で、cat属性がtrueのものを優先的に取得し、存在しない場合は最初のSpotImageを取得する
    spot_images.find_by(cat: true) || spot_images.first
  end

  def process_image(image_url)
    # URLから画像を取得
    temp_file = Tempfile.new(['processed_image', '.png'], encoding: 'ascii-8bit')
    URI.open(image_url) do |image|
      temp_file.binmode
      temp_file.write(image.read)
      temp_file.rewind
    end
  
    # MiniMagickを使用して画像を加工
    image = MiniMagick::Image.open(temp_file.path)
    image.resize "1200x630"
    image.format "webp"
    image.write(temp_file.path)
  
    # CarrierWave::SanitizedFileオブジェクトを作成
    sanitized_file = CarrierWave::SanitizedFile.new(temp_file)
  
    # Uploaderを使用して画像を保存
    uploader = ProcessedImageUploader.new(self)
    uploader.store!(sanitized_file)

    # `ogp_image` カラムを更新
    self.ogp_image = uploader.file
  
    # 一時ファイルを閉じて削除
    temp_file.close
    temp_file.unlink

    # デバッグメッセージ
    puts "Uploader URL: #{uploader.url(:ogp)}"
  
    # 加工された画像のURLを返す
    uploader.url(:ogp)
  end

  # Geocoding setup
  geocoded_by :address  # 使用する地名解決にはaddress属性を利用（ここはモデルの実際の属性に依存）
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  def self.ransackable_attributes(auth_object = nil)
    ["address", "category_id", "created_at", "id", "latitude", "longitude", "name", "opening_hours", "phone_number", "place_id", "postal_code", "prefecture_id", "rating", "updated_at", "web_site","foster_parents","adoption_event"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "prefecture", "spot_images"]
  end

  private

  def default_image_url
    ActionController::Base.helpers.asset_path('default.webp')
  end

  def generate_ogp_image
    if prioritized_spot_image.present?
      proxy_image_url = Rails.application.routes.url_helpers.proxy_image_url(photo_reference: prioritized_spot_image.image, host: Rails.env.production? ? 'https://nekospot.jp' : 'http://localhost:3000')
      self.ogp_image = process_image(proxy_image_url)
    end
  end

  def should_generate_ogp_image?
    ogp_image.blank? || prioritized_spot_image.image_changed?
  end
end
