class AddImagesToReviews < ActiveRecord::Migration[7.1]
  def change
    add_column :reviews, :images, :json
  end
end
