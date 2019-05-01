FactoryBot.define do
  factory :user do
    uid { rand(1..(2**31)).to_s}
    provider { "github" }
    username { Faker::Name.first_name }
    email { Faker::Internet.email  }
  end
end
