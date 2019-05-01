FactoryBot.define do
  factory :product do
    # category { %w(birthday wedding chocolate vanilla buttercream).sample}
    prod_name { Faker::Dessert.variety + ' ' + Faker::Dessert.topping + ' ' + Faker::Dessert.flavor}
    description { Faker::Coffee.notes}
    price { Faker::Number.decimal(2, 2)}
    inv_qty { Faker::Number.between(0, 30)}
    active { Faker::Boolean.boolean}
    image { "image test"}
    user 
  end
end
