class SpotsController < ApplicationController

  def map
    @user = current_user
    @spots = Spot.includes(:spot_images).all.map do |spot|
      spot.as_json(only: [:id, :name, :latitude, :longitude, :address, :rating]).merge(
        image: spot.spot_images.first&.image,
        category: spot.category.name
      )
    end
    @spots_json = @spots.to_json
  end

end
