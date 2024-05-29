class ApplicationController < ActionController::Base
    before_action :config_permitted_parameters, if: :devise_controller?
    after_action :store_location

    # アクセスされたページのURLをセッションに保存するメソッド
    def store_location
        if (request.fullpath != "/users/sign_in" && #現在のページのフルパスが、ログインページ、新規登録ページ、非同期通信、TOPページではない場合
            request.fullpath != "/users/sign_up" &&
            request.fullpath != "/users/sign_out" &&
            request.fullpath != "/" &&
            !request.xhr?) # 現在のリクエストが非同期通信ではない場合にtrue
          session[:previous_url] = request.fullpath #現在のページのフルパスを取得するメソッド。
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
end
