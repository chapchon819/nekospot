class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_spot, only: [:new, :create, :edit, :update]
  before_action :set_review, only: [:edit, :update, :destroy]

  def new
    @review = Review.new
  end

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      flash.now[:success] = "口コミを投稿しました"
      render turbo_stream: [
        turbo_stream.prepend("reviews", @review),
        turbo_stream.update("flash", partial: "layouts/flash_messages")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @review.update(review_params.except(:spot_id))
      flash.now[:success] = "口コミを更新しました"
      render turbo_stream: [
        turbo_stream.replace(@review),
        turbo_stream.update("flash", partial: "layouts/flash_messages")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy!
    flash.now[:success] = "口コミを更新しました"
    render turbo_stream: [
      turbo_stream.remove(@review),
      turbo_stream.update("flash", partial: "layouts/flash_messages")
    ], status: :see_other
  end

  private

  def review_params
    params.require(:review).permit(:rating, :body).merge(spot_id: params[:spot_id])
  end

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end
end
