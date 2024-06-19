class CreateReviewTags < ActiveRecord::Migration[7.1]
  def change
    create_table :review_tags do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :review, null: false, foreign_key: true

      t.timestamps
    end
    add_index :review_tags, [:review_id, :tag_id], unique: true
  end
end
