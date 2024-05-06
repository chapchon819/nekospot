class SpotsController < ApplicationController
  before_action :set_map_data, only: :index

  def index
    @user = current_user
    @spot_objects = Spot.includes(:spot_images, :category).all
    
    @spots = Spot.includes(:spot_images, :category).all.map do |spot|
      spot.as_json(only: [:id, :name, :latitude, :longitude, :address, :rating]).merge(
        image: spot.spot_images.first&.image,
        category: spot.category.name
      )
    end
    @spots_json = @spots.to_json
  end

  def list
    @latitude = params[:latitude]
    @longitude = params[:longitude]
    @radius = params[:radius] || 10 # デフォルトは10km

    @spots = Spot.includes(:spot_images, :category).near([@latitude, @longitude], @radius, units: :km).map do |spot|
      spot.as_json(only: [:id, :name, :latitude, :longitude, :address, :rating]).merge(
        image: spot.spot_images.first&.image,
        category: spot.category.name
      )
    end
    @spots_json = @spots.to_json
    render partial: "spots/list", locals: { spots: @spots }
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def set_map_data
    gon.api_key = ENV['GMAP_API_KEY']
  end

end
