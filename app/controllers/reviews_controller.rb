class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_spot, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_review, only: [:edit, :update, :destroy]

  def new
    @review = Review.new
  end

  def create
    @review = current_user.reviews.build(review_params)
    # フォームから送信されたタグの情報を取り出す。空の場合は[]を使う
    tag_ids_param = params[:review][:tag_ids].first || "[]"
    tag_list = if tag_ids_param.present?
                  JSON.parse(tag_ids_param).map { |tag| tag["value"] }
                else
                  []
                end

    Rails.logger.debug "tag_list: #{tag_list.inspect}"
    if @review.save
      reviews_data
      @review.save_tags(tag_list)
      flash.now[:success] = "口コミを投稿しました"
      render turbo_stream: [
        turbo_stream.prepend("reviews", partial: "reviews/review", locals: { review: @review }),
        turbo_stream.replace("average_rating", partial: "spots/average_rating"),
        turbo_stream.replace("reviews_count", partial: "spots/reviews_count"),
        turbo_stream.replace("review_tab", partial: "spots/review_tab"),
        turbo_stream.update("flash", partial: "layouts/flash_messages"),
        turbo_stream.replace("no_reviews", partial: "reviews/review_list", locals: { spot: @review.spot })
      ]
    else
      reviews_data
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @tag_list = @review.review_tags.joins(:tag).pluck('tags.name').join(', ')
  end

  def update
    # 現在のレビューに関連付けられている画像をexisting_imagesに保持
    existing_images = @review.images

    # review_paramsからspot_idとimagesを除いた属性を@reviewに割り当て
    @review.assign_attributes(review_params.except(:spot_id, :images))

    # 新しい画像が存在する場合、既存の画像に追加。存在しない場合は、元の画像を保持する。
    if review_params[:images].present?
      @review.images += review_params[:images]
    else
      @review.images = existing_images
    end

    # 削除する画像のインデックスが指定されている場合、その画像を削除する。インデックスはカンマで分割。
    if params[:review][:remove_image_at].present?
      params[:review][:remove_image_at].split(',').each do |index|
        @review.remove_image_at_index(index.to_i)
      end
    end
    # 投稿されたタグの情報を取り出す。空の場合は[]を使う
    tag_ids_param = params[:review][:tag_ids].first || "[]"
    tag_list = if tag_ids_param.present?
                JSON.parse(tag_ids_param).map { |tag| tag["value"] }
              else
                []
              end

    # 画像のバリデーションが成功し、レビューが保存できた場合
    if @review.save
      reviews_data #レビューに関連するデータを更新し
      @review.save_tags(tag_list) #タグを保存する。
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
      turbo_stream.update("flash", partial: "layouts/flash_messages"),
      (@review.spot.reviews.count.zero? ? turbo_stream.replace("reviews_list", partial: "spots/no_reviews") : nil)
    ].compact,status: :see_other
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

  def show
    review = Review.last
    @user = review.user if review.present?
    @review = Review.find(params[:id])
    @reviews = @user.reviews.includes(:spot)
    # 最初の画像ファイル名を取得
    first_image_file_name = @review.images.first

  # 最初の画像ファイル名を取得
  first_image_file_name = @review.images.first.identifier
  # アップローダーインスタンスを作成し、最初の画像ファイルをストレージから取得
  image_uploader = ImageUploader.new(@review, :images)
  image_uploader.retrieve_from_store!(first_image_file_name)
  # OGPバージョンのURLを取得
  @first_ogp_image_url = image_uploader.ogp.url
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
