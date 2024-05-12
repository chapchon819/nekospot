class Review < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :rating, presence: true
  validates :body, length: { maximum: 400 }
end
