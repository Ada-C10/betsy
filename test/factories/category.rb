FactoryBot.define do
  factory :category do
    category { Faker::Name.first_name }
  end
end
