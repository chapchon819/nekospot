class DiagnosticAnswer < ApplicationRecord
  belongs_to :diagnostic_question
  has_many :diagnostic_answer_categories
  has_many :categories, through: :diagnostic_answer_categories
  
  validates :diagnostic_question_id, presence: true
  validates :answer, presence: true, uniqueness: true
end
