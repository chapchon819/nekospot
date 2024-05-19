class SpotBookmark < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :user_id, uniqueness: { scope: :spot_id }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "spot_id", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["spot", "user"]
  end
end
