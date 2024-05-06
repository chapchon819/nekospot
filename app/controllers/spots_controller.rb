class SpotsController < ApplicationController
  before_action :set_map_data, only: :index

  def index
    @user = current_user
    @spots = Spot.includes(:spot_images, :category).all
    
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
    latitude = params[:latitude].to_f
    longitude = params[:longitude].to_f
    radius = params[:radius] || 10 # デフォルトは10km

    @spots = Spot.includes(:spot_images, :category).near([latitude, longitude], radius, units: :km).limit(10)

    # JSON形式でスポットのデータをフロントエンドに送り返します
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
    gon.api_key = ENV['GMAP_API_KEY']
    gon.spots = Spot.includes(:spot_images, :category).all.map do |spot|
      spot.as_json(only: [:id, :name, :latitude, :longitude, :address, :rating]).merge(
        image: spot.spot_images.first&.image,
        category: spot.category.name
      )
    end
  end

end
