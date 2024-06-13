class CreateDiagnosticAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :diagnostic_answers do |t|
      t.references :diagnostic_question, null: false, foreign_key: true
      t.string :answer
      t.integer :score

      t.timestamps
    end
  end
end
