class AddOgpImageToSpots < ActiveRecord::Migration[7.1]
  def change
    add_column :spots, :ogp_image, :string
  end
end
