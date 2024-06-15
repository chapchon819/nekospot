class AddColumnToSpots < ActiveRecord::Migration[7.1]
  def change
    add_column :spots, :x_account, :string
  end
end
