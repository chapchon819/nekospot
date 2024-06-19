class Review < ApplicationRecord
  belongs_to :user
  belongs_to :spot
  has_many :helpfuls, dependent: :destroy
  has_many :review_tags, dependent: :destroy
  has_many :tags, through: :review_tags
  attr_accessor :images_cache
  mount_uploaders :images, ImageUploader

  validates :rating, presence: true, numericality: { in: 1..5, message: "を入力してください" }
  validates :body, length: { maximum: 400 }
  validate :validate_image_count

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

  def save_tags(save_review_tags)
  # 既存のタグをクリアすることで、タグ編集時の重複を防ぐ
  self.tags.clear

  save_review_tags.each do |new_name| #カラムの中から同じ値がないか探して、あればそのままfindの動き、なければcreateの動きで新たにカラムに保存
    review_tag = Tag.find_or_create_by(name: new_name)
    self.tags << review_tag #タグを関連付ける
  end
  end

  private

  def validate_image_count
    if images.size > 3
      errors.add(:images, "画像のアップロードは３枚までです。")
    end
  end
end
