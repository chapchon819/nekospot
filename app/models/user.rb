class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :spot_bookmarks, dependent: :destroy
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
end
