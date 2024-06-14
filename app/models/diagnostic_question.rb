class DiagnosticQuestion < ApplicationRecord
    has_many :diagnostic_answers

    validates :question, presence: true, uniqueness: true

    # その質問が最後の質問かどうかを判定するメソッド
    def last?
        self == DiagnosticQuestion.order(:id).last
    end
end
