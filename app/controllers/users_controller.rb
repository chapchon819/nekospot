class UsersController < ApplicationController
  def show
    @user = current_user
    @reviews = @user.reviews.includes(:spot).order(created_at: :desc).page(params[:page]).per(10)
    @total_helpfuls = @user.reviews.joins(:helpfuls).count
  end
end
