class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
        basic_action
    end

    def line
      basic_action
    end
  
    private
    
    def basic_action
      @omniauth = request.env["omniauth.auth"]
      Rails.logger.info("Omniauth data: #{@omniauth}")
      if @omniauth.present?
        @profile = User.find_or_initialize_by(provider: @omniauth["provider"], uid: @omniauth["uid"])
        if @profile.email.blank?
          email = @omniauth["info"]["email"] ? @omniauth["info"]["email"] : "#{@omniauth["uid"]}-#{@omniauth["provider"]}@example.com"
          @profile = current_user || User.create!(provider: @omniauth["provider"], uid: @omniauth["uid"], email: email, name: @omniauth["info"]["name"], password: Devise.friendly_token[0, 20])
        end
        @profile.set_values(@omniauth)
        sign_in(:user, @profile)
      end
      #ログイン後のflash messageとリダイレクト先を設定
      flash[:notice] = "ログインしました"
      redirect_to map_spots_path
    end
  
    def fake_email(uid, provider)
      "#{auth.uid}-#{auth.provider}@example.com"
    end
end
