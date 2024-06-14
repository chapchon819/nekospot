class AddColumnsToSpots < ActiveRecord::Migration[7.1]
  def change
    add_column :spots, :foster_parents, :integer, null: false, default: 0
    add_column :spots, :adoption_event, :integer, null: false, default: 0
    add_column :spots, :age_limit, :integer, null: false, default: 0
  end
end
