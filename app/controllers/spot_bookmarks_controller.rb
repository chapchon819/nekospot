class SpotBookmarksController < ApplicationController
    before_action :authenticate_user!, only: [:create, :destroy]

    def create
        @spot = Spot.find(params[:spot_id])
        current_user.bookmark(@spot)
        flash.now[:success] = "スポットをお気に入りに追加しました"
    end

    def destroy
        @spot = current_user.spot_bookmarks.find(params[:id]).spot
        current_user.unbookmark(@spot)
        flash.now[:success] = "スポットをお気に入りから削除しました"
    end
end
