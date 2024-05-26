class Review < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :rating, presence: true, numericality: { in: 1..5, message: "を入力してください" }
  validates :body, length: { maximum: 400 }

  def self.ransackable_attributes(auth_object = nil)
    ["body", "created_at", "id", "id_value", "rating", "spot_id", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["spot", "user"]
  end
end
