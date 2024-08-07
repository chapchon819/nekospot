FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Sample Tag #{n}" }
  end
end
