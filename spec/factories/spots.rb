FactoryBot.define do
  factory :spot do
    name { "test spot" }
    address { "nekospot" }
    latitude { 12.3456 }
    longitude { 123.5678 }
  end
end
