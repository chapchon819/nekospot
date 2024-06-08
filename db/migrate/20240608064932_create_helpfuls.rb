class CreateHelpfuls < ActiveRecord::Migration[7.1]
  def change
    create_table :helpfuls do |t|
      t.references :user, null: false, foreign_key: true
      t.references :review, null: false, foreign_key: true

      t.timestamps
    end
  end
end
