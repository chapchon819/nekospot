FactoryBot.define do
  factory :user do
    name { "ねこスポット" }
    email { "nekospot@example.com" }
    encrypted_password { "nekospot" }
    role { 0 }
  end
end
