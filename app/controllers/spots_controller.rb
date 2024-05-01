class SpotsController < ApplicationController

  def index
    @user = current_user
    @spots = Spot.includes(:spot_images).all.map do |spot|
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

    @spots = Spot.near([@latitude, @longitude], @radius, units: :km)
    render partial: "spots/list", locals: { spots: @spots }
  end

end
