class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      redirect_to spot_path(@review.spot), success: "口コミを投稿しました"
    else
      flash[:error] = "口コミの投稿に失敗しました"
      redirect_to spot_path(@review.spot)
    end
  end

  def update
  end

  def destroy
  end

  private

  def review_params
    params.require(:review).permit(:rating, :body).merge(spot_id: params[:spot_id])
  end
end
