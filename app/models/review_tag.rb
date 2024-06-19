class ReviewTag < ApplicationRecord
  belongs_to :tag
  belongs_to :review
  validates :tag_id, uniqueness: { scope: :review_id }
end
