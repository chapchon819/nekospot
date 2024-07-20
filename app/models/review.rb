class Review < ApplicationRecord
  belongs_to :user
  belongs_to :spot
  has_many :helpfuls, dependent: :destroy
  has_many :review_tags, dependent: :destroy
  has_many :tags, through: :review_tags
  attr_accessor :images_cache, :tag_names
  mount_uploaders :images, ImageUploader




  validates :rating, presence: true, numericality: { in: 1..5, message: "を入力してください" }
  validates :body, length: { maximum: 400 }
  validate :validate_image_count
  validate :validate_tag_count
  #validate :validate_images

  after_save :log_review_save

  def log_review_save
    Rails.logger.debug "Review saved with images: #{images.inspect}"
  end

  # 画像削除を処理するメソッド
  def remove_image_at_index(index)
    remain_images = self.images # 現在の画像を複製
    remain_images.delete_at(index)
    self.images = remain_images
  end

  def self.ransackable_attributes(auth_object = nil)
    ["body", "created_at", "id", "id_value", "rating", "spot_id", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["spot", "user"]
  end

  def save_tags(tag_list)
    if tag_list.size > 5
      errors.add(:tags, "タグは5件までです。")
      return false
    end

    self.tags.clear
    tag_list.each do |new_name|
      review_tag = Tag.find_or_create_by(name: new_name)
      self.tags << review_tag
    end
  end

  # レビューの文字数を判定
  def long_body?(length = 10)
    body.length > length
  end

  # タグに基づいたレビューをフィルタリングするスコープ
  scope :review_tag, ->(tag_id) { joins(:tags).where(tags: { id: tag_id }) }

  private

  def validate_image_count
    if images.size > 3
      errors.add(:images, "画像のアップロードは３枚までです。")
    end
  end

  def validate_tag_count
    if tags.size > 5
      errors.add(:tags, "タグは5件までです。")
    end
  end


=begin %>
  def validate_images
    return if images.blank? || images.all?(&:blank?)

    cleaned_images = images.reject(&:blank?)
    inappropriate_images = []

    cleaned_images.each do |image|
      result = Vision.image_analysis(image)
      inappropriate_images << image unless result
    end

    if inappropriate_images.any?
      errors.add(:images, '不適切な画像が含まれています')
    end
  end
  <%
=end
end
