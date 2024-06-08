class HelpfulsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :destroy]

    def create
        @review = Review.find(params[:review_id])
        current_user.helpful(@review)
        flash.now[:success] = "参考にしました！"
    end

    def destroy
        @review = current_user.helpfuls.find(params[:id]).review
        current_user.unhelpful(@review)
        flash.now[:success] = "参考になった！を取り消しました。"
    end
end
