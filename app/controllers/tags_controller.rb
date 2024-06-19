class TagsController < ApplicationController
    def search
        query = params[:query]
        @tags = Tag.where("name LIKE ?", "%#{query}%")
        #　値を取得する
        @tags = @tags.pluck(:name)
        render json: @tags
    end
end
