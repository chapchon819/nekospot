class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_spot, only: [:new, :create]

  def new
    @review = Review.new
  end

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      flash.now.notice = "口コミを投稿しました"
      render turbo_stream: [
        turbo_stream.prepend("reviews", @review),
        turbo_stream.update("flash", partial: "layouts/flash_messages")
      ]
    else
      render :new, status: :unprocessable_entity
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

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end
end
