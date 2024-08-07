FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "password" }
    password_confirmation { "password" }
    provider { "google_oauth2" }
    uid { "123456" }
  end
end
