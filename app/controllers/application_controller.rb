class ApplicationController < ActionController::Base
    before_action :config_permitted_parameters, if: :devise_controller?
    private
      def config_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
        devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :name, :avatar_cache])
      end
end
