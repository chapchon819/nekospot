class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception #CSRF保護を有効にする
    before_action :config_permitted_parameters, if: :devise_controller?
    after_action :store_location
    before_action :log_session_details

    # アクセスされたページのURLをセッションに保存するメソッド
    def store_location
        if (request.fullpath != "/users/sign_in" && #現在のページのフルパスが、ログインページ、新規登録ページ、非同期通信、TOPページではない場合
            request.fullpath != "/users/sign_up" &&
            request.fullpath != "/users/sign_out" &&
            !request.fullpath.match?(/^\/spots\/list/) &&
            request.fullpath != "/" &&
            !request.fullpath.match?(/^https:\/\/lh3\.googleusercontent\.com\/places\//) && # Google PlacesのURLを除外
            !request.fullpath.match?(/^\/spot_images\//) &&
            !request.xhr?) # 現在のリクエストが非同期通信ではない場合にtrue
          session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/ || request.xhr? #現在のページのフルパスを取得するメソッド。
        end
    end
  
    #ログイン後のリダイレクトをログイン前のページにする
    def after_sign_in_path_for(resource)
      session[:previous_url] || map_spots_path #session[:previous_url]が存在する場合はそのURLを、存在しない場合はmap_spots_pathを返す
    end

    private
      def config_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
        devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :name, :avatar_cache])
      end

      def log_session_details
        Rails.logger.info("Session ID: #{session.id}")
        Rails.logger.info("Session Data: #{session.to_hash}")
        Rails.logger.info("CSRF Token: #{session[:_csrf_token]}")
      end

      def verify_session_id
        if session[:saved_session_id] && session[:saved_session_id] != session.id
          Rails.logger.warn("Session ID mismatch: expected #{session[:saved_session_id]}, got #{session.id}")
        end
      end
end
