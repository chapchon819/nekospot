class Review < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :rating, presence: true, numericality: { in: 1..5, message: "を入力してください" }
  validates :body, length: { maximum: 400 }
end
