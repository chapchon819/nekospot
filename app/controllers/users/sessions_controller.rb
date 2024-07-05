# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    # 明示的にRedisからセッションを削除する
    if session[:session_id]
      redis_store = ActiveSupport::Cache::RedisStore.new(url: ENV['REDIS_URL'], namespace: 'session')
      redis_store.delete(session[:session_id])
    end

    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
