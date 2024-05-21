class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_spot, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :reviews_data, only: [:create, :update, :destroy]

  def new
    @review = Review.new
  end

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      flash.now[:success] = "口コミを投稿しました"
      render turbo_stream: [
        turbo_stream.prepend("reviews", @review),
        turbo_stream.replace("average_rating", partial: "spots/average_rating"),
        turbo_stream.replace("reviews_count", partial: "spots/reviews_count"),
        turbo_stream.replace("review_tab", partial: "spots/review_tab"),
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
        turbo_stream.replace("average_rating", partial: "spots/average_rating"),
        turbo_stream.update("flash", partial: "layouts/flash_messages")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy!
    flash.now[:success] = "口コミを削除しました"
    render turbo_stream: [
      turbo_stream.remove(@review),
      turbo_stream.replace("average_rating", partial: "spots/average_rating"),
      turbo_stream.replace("reviews_count", partial: "spots/reviews_count"),
      turbo_stream.replace("review_tab", partial: "spots/review_tab"),
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

  def reviews_data
    @reviews = @spot.reviews.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
    @average_rating = @spot.reviews.average(:rating).to_f
    @all_reviews_count = @spot.reviews.count
  end
end
