class DiagnosticAnswerCategory < ApplicationRecord
  belongs_to :diagnostic_answer
  belongs_to :category

  validates :diagnostic_answer_id, presence: true
  validates :category_id, presence: true
end
