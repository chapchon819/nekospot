class VisitsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :destroy]

    def create
        @spot = Spot.find(params[:spot_id])
        current_user.visited(@spot)
        flash.now[:success] = "訪問済みにしました"
    end

    def destroy
        @spot = current_user.visits.find(params[:id]).spot
        current_user.unvisited(@spot)
        flash.now[:success] = "訪問済みを取り消しました"
    end
end
