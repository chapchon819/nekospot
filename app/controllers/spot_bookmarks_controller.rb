class SpotBookmarksController < ApplicationController
    before_action :authenticate_user!, only: [:create, :destroy]

    def create
        @spot = Spot.find(params[:spot_id])
        current_user.bookmark(@spot)
    end

    def destroy
        @spot = current_user.spot_bookmarks.find(params[:id]).spot
        current_user.unbookmark(@spot)
    end
end
