class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_spot, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_review, only: [:edit, :update, :destroy]

  def new
    @review = Review.new
  end

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      reviews_data
      flash.now[:success] = "口コミを投稿しました"
      render turbo_stream: [
        turbo_stream.prepend("reviews", @review),
        turbo_stream.replace("average_rating", partial: "spots/average_rating"),
        turbo_stream.replace("reviews_count", partial: "spots/reviews_count"),
        turbo_stream.replace("review_tab", partial: "spots/review_tab"),
        turbo_stream.update("flash", partial: "layouts/flash_messages")
      ]
    else
      reviews_data
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
  # 現在の画像を保持
  existing_images = @review.images

  # レビューの更新
  @review.assign_attributes(review_params.except(:spot_id, :images))

  # 既存の画像に新しい画像を追加
  if review_params[:images].present?
    @review.images += review_params[:images]
  else
    @review.images = existing_images
  end

if params[:review][:remove_image_at].present?
  params[:review][:remove_image_at].split(',').each do |index|
    @review.remove_image_at_index(index.to_i)
  end
end
    if @review.save
      reviews_data
      flash.now[:success] = "口コミを更新しました"
      render turbo_stream: [
        turbo_stream.replace(@review),
        turbo_stream.replace("average_rating", partial: "spots/average_rating"),
        turbo_stream.update("flash", partial: "layouts/flash_messages")
      ]
    else
      reviews_data
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy!
    reviews_data
    flash.now[:success] = "口コミを削除しました"
    render turbo_stream: [
      turbo_stream.remove(@review),
      turbo_stream.replace("average_rating", partial: "spots/average_rating"),
      turbo_stream.replace("reviews_count", partial: "spots/reviews_count"),
      turbo_stream.replace("review_tab", partial: "spots/review_tab"),
      turbo_stream.update("flash", partial: "layouts/flash_messages")
    ], status: :see_other
  end

  def search
    query = params[:q]
    if query.present?
      @reviews = Review.ransack(spot_name_or_spot_address_or_body_cont: query).result
      @search_by_spot_name = Review.ransack(spot_name_cont: query).result.exists?
      @search_by_spot_address = Review.ransack(spot_address_cont: query).result.exists?
      @search_by_body = Review.ransack(body_cont: query).result.exists?
    else
      @reviews = Review.none
      @search_by_spot_name = false
      @search_by_spot_address = false
      @search_by_body = false
    end

    respond_to do |format|
      format.html # For normal HTML requests
      format.json # For AJAX requests
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :body, { images: [] }, :images_cache).merge(spot_id: params[:spot_id])
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
