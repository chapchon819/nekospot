FactoryBot.define do
  factory :review do
    association :user
    association :spot
    rating { rand(1..5) }
    body { "nekospot" }
    
    after(:build) do |review|
      review.images = [
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample1.jpg'), 'image/jpg'),
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample2.jpg'), 'image/jpg')
      ]
      review.tags << create_list(:tag, 3)
    end
  end
end
