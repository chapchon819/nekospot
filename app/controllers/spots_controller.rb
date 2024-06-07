class SpotsController < ApplicationController
  before_action :set_map_data, only: :map

  def index
    @categories = Category.all
    @prefectures = Prefecture.all
    @q_spots = Spot.ransack(params[:q])
    @spots = @q_spots.result(distinct: true).includes(:spot_images, :category).page(params[:page]).per(12)
    
    @q_reviews = Review.ransack(params[:q])
    @reviews = @q_reviews.result(distinct: true).select("id, user_id, spot_id, rating, body, created_at, updated_at, images::text AS images").includes(:spot).page(params[:page]).per(12)
  end

  def map
    @user = current_user
    @q = Spot.ransack(params[:q])
    @spots = @q.result(distinct: true).includes(:spot_images, :category)

    if params[:category].present?
      @spots = @spots.where(category_id: params[:category])
    end
    
    latitude = params[:latitude].to_f
    longitude = params[:longitude].to_f

    respond_to do |format|
      format.html
      format.json do
        render json: {
          spots: @spots.as_json(include: [:spot_images, :category])
        }
      end
    end
  end

  def list
    @q = Spot.ransack(params[:q])
    search_results = @q.result(distinct: true)

    latitude = params[:latitude].to_f
    longitude = params[:longitude].to_f
    radius = params[:radius] || 10 # デフォルトは10km

    if params[:category].present?
      search_results = search_results.where(category_id: params[:category])
    end
    
    @spots = search_results.includes(:spot_images, :category).near([latitude, longitude], radius, units: :km).limit(10)

    # JSON形式でスポットのデータをフロントエンドに送り返す
    spots_json = @spots.map do |spot|
      spot.as_json(only: [:id, :name, :latitude, :longitude, :address, :rating]).merge(
        image: spot.spot_images.first&.image,
        category: spot.category.name,
        category_id: spot.category.id
      )
    end

    render json: spots_json
  end

  def bookmarks
    @q = current_user.spot_bookmarks.joins(:spot).ransack(params[:q])
    @bookmark_spots = @q.result(distinct: true).includes(:spot).order(created_at: :desc)

    bookmarked_spots = current_user.spot_bookmarks.joins(:spot).map(&:spot)
    @categories = bookmarked_spots.map(&:category).uniq
    prefecture_ids = bookmarked_spots.map(&:prefecture_id).uniq
    @prefectures = Prefecture.find(prefecture_ids)
  end

  def show
    @user = current_user
    @spot = Spot.find(params[:id])
    @review = Review.new(spot: @spot)
    @reviews = @spot.reviews.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
    @all_reviews_count = @spot.reviews.count
    @average_rating = @spot.reviews.average(:rating).to_f
  end

  def search
    query = params[:q]
    if query.present?
      @spots = Spot.ransack(name_or_address_cont: query).result
      @search_by_name = Spot.ransack(name_cont: query).result.exists?
      @search_by_address = Spot.ransack(address_cont: query).result.exists?
    else
      @spots = Spot.none
      @search_by_name = false
      @search_by_address = false
    end

    respond_to do |format|
      format.html # For normal HTML requests
      format.json # For AJAX requests
    end
  end

  def set_map_data
    @q = Spot.ransack(params[:q])  # フリーワード検索のパラメータを受け取る
    @spots = @q.result(distinct: true).includes(:spot_images, :category)

    gon.api_key = ENV['GMAP_API_KEY']
    gon.spots = @spots.map do |spot|
      spot.as_json(only: [:id, :name, :latitude, :longitude, :address, :rating]).merge(
        image: spot.spot_images.first&.image,
        category: spot.category.name,
        category_id: spot.category.id
      )
    end
  end

end
