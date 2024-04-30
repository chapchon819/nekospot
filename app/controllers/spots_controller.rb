class SpotsController < ApplicationController

  def map
    @user = current_user
    @spots = Spot.all
    @spots_json = @spots.to_json(only: [:id, :name, :latitude, :longitude, :address, :rating])
  end


end
