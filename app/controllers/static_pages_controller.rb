class StaticPagesController < ApplicationController
  def index
    cat_image_ids = SpotImage.where(cat: true).pluck(:id)
    random_ids = cat_image_ids.sample(10)
    @cat_images = SpotImage.where(id: random_ids)
  end

  def privacy_policy; end

  def terms_of_use; end
end
