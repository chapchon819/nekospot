class AddCatToSpotImages < ActiveRecord::Migration[7.1]
  def change
    add_column :spot_images, :cat, :boolean, default: false
  end
end
