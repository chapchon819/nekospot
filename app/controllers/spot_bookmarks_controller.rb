class SpotBookmarksController < ApplicationController
    before_action :authenticate_user!, only: [:create, :destroy]

    def create
        spot = Spot.find(params[:spot_id])
        current_user.bookmark(spot)
        flash[:success] = "お気に入りに登録しました"
        redirect_to spots_path
    end

    def destroy
        spot = current_user.spot_bookmarks.find(params[:id]).spot
        current_user.unbookmark(spot)
        flash[:success] = "お気に入りを解除しました"
        redirect_to spots_path
    end
end
