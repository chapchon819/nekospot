class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :log_session_details, only: [:failure, :google_oauth2, :line]

    def google_oauth2
      logger.debug "Entering OmniauthCallbacksController#google_oauth2"
        basic_action
    end

    def line
      basic_action
    end

    def failure
      redirect_to root_path
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
      redirect_to after_sign_in_path_for(@profile)
    end
  
    def fake_email(uid, provider)
      "#{auth.uid}-#{auth.provider}@example.com"
    end
  
    def log_session_details
      Rails.logger.info("Session ID: #{session.id}")
      Rails.logger.info("Session Data: #{session.to_hash}")
      Rails.logger.info("CSRF Token: #{session[:_csrf_token]}")
    end
end
