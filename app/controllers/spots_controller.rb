class SpotsController < ApplicationController
  require 'open-uri'
  before_action :set_map_data, only: [:map, :list]

  def index
    review = Review.last
    @user = review.user if review.present?
    @categories = Category.all
    @prefectures = Prefecture.all
    @tags = Tag.all
    # params[:q][:adoption_event_eq]が配列になっている場合に対応
    if params[:q] && params[:q][:adoption_event_eq].is_a?(Array)
      params[:q][:adoption_event_eq] = params[:q][:adoption_event_eq].first
    end
    @q_spots = Spot.ransack(params[:q])
    page_param = params[:page].is_a?(Array) ? params[:page].first : params[:page]
    sorted_spots = apply_sort_scope(@q_spots.result(distinct: true))
    @spots = sorted_spots.includes(:spot_images, :category).page(page_param.to_i).per(12)
    Rails.logger.debug "SQL Query for spots: #{@spots.to_sql}"
    @spots_count = sorted_spots.count
    @current_sort = params.dig(:q, :s) || "created_at asc"
    
    @q_reviews = Review.ransack(params[:q])

    if params[:tag_id].present?
      filtered_reviews = Review.review_tag(params[:tag_id])
      @reviews = filtered_reviews.includes(:user, :spot, :tags).page(params[:page]).per(12)
    else
      filtered_reviews = @q_reviews.result(distinct: false).includes(:user, :spot, :tags)
      #distinct_reviews = filtered_reviews.select('DISTINCT ON (reviews.id) reviews.id, reviews.user_id, reviews.spot_id, reviews.rating, reviews.body, reviews.created_at, reviews.updated_at, reviews.images')
      @reviews = filtered_reviews.page(params[:page]).per(12)
    end
  end

  def map
    @tags = Tag.all
    @categories = Category.all
    @prefectures = Prefecture.all
    @user = current_user
    @q = Spot.ransack(params[:q])
    @spots = @q.result(distinct: true).includes(:spot_images, :category)
  
    if params[:category].present?
      @spots = @spots.where(category_id: params[:category])
    end
    
    respond_to do |format|
      format.html
      format.json { render json: @spots.as_json(include: [:spot_images, :category]) }
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
        image: spot.prioritized_spot_image&.image,
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
    @visited_spots = current_user.visits.includes(:user).order(created_at: :desc)
  end

  def visits
    @visited_spots = current_user.visits.includes(:user).order(created_at: :desc)
  end

  def show
    @user = current_user
    @spot = Spot.find(params[:id])
    Rails.logger.debug "Received tag_id: #{params[:tag_id]}" # デバッグ用ログ
    @review = Review.new(spot: @spot)
    if params[:tag_id].present?
      @reviews = @spot.reviews.joins(:tags).where(tags: { id: params[:tag_id] }).includes(:user).order(created_at: :desc).page(params[:page]).per(10)
      logger.debug "Filtered reviews for tag_id: #{params[:tag_id]}"
    else
      @reviews = @spot.reviews.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
      logger.debug "No tag_id provided, showing all reviews"
    end
    @all_reviews_count = @spot.reviews.count
    @average_rating = @spot.reviews.average(:rating).to_f
    @prioritized_image = @spot.prioritized_spot_image # 優先的に表示する画像を取得
    @image_url = @spot.ogp_image
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

  def proxy_image
    photo_reference = params[:photo_reference]
    url = "https://maps.googleapis.com/maps/api/place/photo?maxheight=1000&photo_reference=#{photo_reference}&key=#{ENV['GMAP_API_KEY']}"
    
    begin
      image_data = URI.open(url).read
      send_data image_data, type: 'image/jpeg', disposition: 'inline'
    rescue OpenURI::HTTPError => e
      render plain: "Image not found", status: :not_found
    rescue => e
      render plain: "An error occurred: #{e.message}", status: :internal_server_error
    end
  end

  private

  def apply_sort_scope(spots)
    case params[:q]&.dig(:s)
    when 'rating desc'
      Rails.logger.debug "Applying sorted_by_rating scope"
      spots.reorder(Arel.sql('rating DESC NULLS LAST'))
    when 'created_at asc'
      Rails.logger.debug "Applying sorted_by_created_at_asc scope"
      spots.reorder(:created_at)
    when 'created_at desc'
      Rails.logger.debug "Applying sorted_by_created_at_desc scope"
      spots.reorder(created_at: :desc)
    else
      Rails.logger.debug "No specific sorting applied"
      spots
    end
  end

  def set_map_data
    @q = Spot.ransack(params[:q])  # フリーワード検索のパラメータを受け取る
    @spots = @q.result(distinct: true).includes(:spot_images, :category)

    gon.api_key = ENV['GMAP_API_KEY']
    gon.spots = @spots.map do |spot|
      spot.as_json(only: [:id, :name, :latitude, :longitude, :address, :rating]).merge(
        image: spot.prioritized_spot_image&.image,
        category: spot.category.name,
        category_id: spot.category.id
      )
    end
  end
end
