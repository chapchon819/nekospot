class SpotBookmarksController < ApplicationController
    before_action :authenticate_user!, only: [:create, :destroy]

    def create
        spot = Spot.find(params[:spot_id])
        current_user.bookmark(spot)
        redirect_to spots_path, success: "お気に入りに登録しました"
    end

    def destroy
        spot = current_user.bookmarks.find(params[:id]).spot
        current_user.unbookmark(spot)
        redirect_to spots_path, success: "お気に入りを解除しました"
    end
end
