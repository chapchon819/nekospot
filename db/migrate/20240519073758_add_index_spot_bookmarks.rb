class AddIndexSpotBookmarks < ActiveRecord::Migration[7.1]
  def change
    add_index :spot_bookmarks, [:user_id, :spot_id], unique: true
  end
end
