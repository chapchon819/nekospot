class CreateDiagnosticQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :diagnostic_questions do |t|
      t.string :question

      t.timestamps
    end
  end
end
