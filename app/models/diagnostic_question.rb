class DiagnosticQuestion < ApplicationRecord
    has_many :diagnostic_answers

    validates :question, presence: true, uniqueness: true
end
