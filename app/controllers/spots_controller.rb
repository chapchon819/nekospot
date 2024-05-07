class SpotsController < ApplicationController
  before_action :set_map_data, only: :index

  def index
    @user = current_user
    @q = Spot.ransack(params[:q])
    @spots = @q.result(distinct: true).includes(:spot_images, :category)
    
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
    
    @spots = search_results.includes(:spot_images, :category).near([latitude, longitude], radius, units: :km).limit(10)

    # JSON形式でスポットのデータをフロントエンドに送り返す
    spots_json = @spots.map do |spot|
      spot.as_json(only: [:id, :name, :latitude, :longitude, :address, :rating]).merge(
        image: spot.spot_images.first&.image,
        category: spot.category.name
      )
    end

    render json: spots_json
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def set_map_data
    @q = Spot.ransack(params[:q])  # フリーワード検索のパラメータを受け取る
    @spots = @q.result(distinct: true).includes(:spot_images, :category)

    gon.api_key = ENV['GMAP_API_KEY']
    gon.spots = @spots.map do |spot|
      spot.as_json(only: [:id, :name, :latitude, :longitude, :address, :rating]).merge(
        image: spot.spot_images.first&.image,
        category: spot.category.name
      )
    end
  end

end
