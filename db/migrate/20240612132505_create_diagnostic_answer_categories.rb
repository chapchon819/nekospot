class CreateDiagnosticAnswerCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :diagnostic_answer_categories do |t|
      t.references :diagnostic_answer, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
