class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader

  has_many :reviews, dependent: :destroy
  has_many :spot_bookmarks, dependent: :destroy
  has_many :bookmark_spots, through: :spot_bookmarks, source: :spot
  has_many :helpfuls, dependent: :destroy
  has_many :helpful_reviews, through: :helpfuls, source: :review
  has_many :visits, dependent: :destroy
  has_many :visited_spots, through: :visits, source: :spot

  enum role: { general: 0, admin: 1 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :omniauthable, omniauth_providers: %i[google_oauth2 line]

  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end
            
  def set_values(omniauth)
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
    credentials = omniauth["credentials"]
    info = omniauth["info"]
      
    access_token = credentials["refresh_token"]
    access_secret = credentials["secret"]
    credentials = credentials.to_json
    name = info["name"]
  end
            
  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end

  def bookmark(spot)
    bookmark_spots << spot
  end

  def unbookmark(spot)
    bookmark_spots.destroy(spot)
  end

  def bookmark?(spot)
    bookmark_spots.include?(spot)
  end

  def helpful(review)
    helpful_reviews << review
  end

  def unhelpful(review)
    helpful_reviews.destroy(review)
  end

  def helpful?(review)
    helpful_reviews.include?(review)
  end

  def visited(spot)
    visited_spots << spot
  end

  def unvisited(spot)
    visited_spots.destroy(spot)
  end

  def visited?(spot)
    visited_spots.include?(spot)
  end
end
