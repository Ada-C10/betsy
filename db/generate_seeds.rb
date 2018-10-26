require 'faker'
require 'date'
require 'csv'

# Merchant seed script
CSV.open('db/merchant_seeds.csv', "w", :write_headers=> true,
  :headers => ["username", "email", "uid", "provider"]) do |csv|

  5.times do
    username = Faker::HarryPotter.character
    email = Faker::Internet.email
    uid = Faker::Number.number(3)
    provider = "github"

    csv << [username, email, uid, provider]
  end
end

# Product seed script
CSV.open('db/product_seeds.csv', "w", :write_headers=> true,
  :headers => ["name", "price", "photo", "stock", "active", "description"]) do |csv|

  50.times do
    name = Faker::Cat.name
    price = Faker::Commerce.price
    photo = 'http://placekitten.com/200/300'
    stock = Faker::Number.number(2)
    active = Faker::Boolean.boolean(0.8)
    description = Faker::Lorem.sentence

    csv << [name, price, photo, stock, active, description]
  end
end

# Order item seed script
CSV.open('db/order_item_seeds.csv', "w", :write_headers=> true,
  :headers => ["quantity", "status"]) do |csv|

  50.times do
    quantity = Faker::Number.number(2)
    status = %w(pending paid complete cancelled).sample

    csv << [quantity, status]
  end
end

# Order seed screipt
CSV.open('db/order_seeds.csv', "w", :write_headers=> true,
  :headers => ["status", "name", "email", "address", "cc_num", "cc_cvv", "cc_expiration"]) do |csv|

  20.times do
    status = %w(paid complete cancelled).sample
    name = Faker::RickAndMorty.character
    email = Faker::Internet.email
    address = Faker::Address.full_address
    cc_num = Faker::Number.number(16)
    cc_cvv = Faker::Number.number(3)
    cc_expiration = Faker::Date.backward(21)


    csv << [status, name, email, address, cc_num, cc_cvv, cc_expiration]
  end
end

# Category seed script
CSV.open('db/category_seeds.csv', "w", :write_headers=> true,
  :headers => ["name"]) do |csv|

  12.times do
    name = Faker::Dog.breed

    csv << [name]
  end
end
