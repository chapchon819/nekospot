class AddColumnUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :avatar, :string
    add_column :users, :role, :integer, null: false, default: 0
  end
end
