class Category < ApplicationRecord
    has_many :spots
    has_many :diagnostic_answer_categories
    has_many :diagnostic_answers, through: :diagnostic_answer_categories
    validates :name, presence: true, uniqueness: true
end
