class CreateSpotBookmarks < ActiveRecord::Migration[7.1]
  def change
    create_table :spot_bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :spot, null: false, foreign_key: true

      t.timestamps
    end
  end
end
