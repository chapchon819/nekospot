class UsersController < ApplicationController
  def show
    @user = current_user
    @reviews = @user.reviews.includes(:spot).order(created_at: :desc)
  end
end
