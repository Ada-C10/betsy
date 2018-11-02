# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
require 'date'

category_failures = []

cate_list = ["Senate", "House", "Midterms", "Swing"]

cate_list.each do |cate|
  category = Category.new
  category.name = cate
  successful = category.save
  if !successful
    category_failures << category
    puts "Failed to save category: #{category.inspect}"
  else
    puts "Created category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} category failed to save"



# user_failures = []
#
# 5.times do |i|
#   user_name = Faker::Name.name
#   user = User.new
#   user.name = user_name
#   user.uid = rand(10)
#   user.provider = "github"
#   successful = user.save
#   if !successful
#     user_failures << user
#     puts "Failed to save user: #{user.inspect}" # so user can check that work to see what happened
#   else
#     puts "Created user: #{user.inspect}"
#   end
# end
#
# puts "Added #{User.count} user records"
# puts "#{user_failures.length} users failed to save"

merchant_failures = []

10.times do |i|
  merchant_name = Faker::GameOfThrones.unique.character
  merchant = Merchant.new
  merchant.type = "Merchant"
  merchant.name = merchant_name
  merchant.uid = rand(10)
  merchant.provider = "github"
  successful = merchant.save
  if !successful
    merchant_failures << merchant
    puts "Failed to save merchant: #{merchant.inspect}" # so user can check that work to see what happened
  else
    puts "Created merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchant failed to save"

product_failures = []

100.times do |i|

  merchant_list = Merchant.all
  state = Faker::Address.state
  product_name = "#{state} Election #{rand(10) + 1}"

  product = Product.new
  product.name = product_name
  product.stock = rand(15) + 1
  product.description = "I don't think anybody knows it was Russia that wrote Lorem Ipsum, but I don't know, maybe it was. It could be Russia, but it could also be China. It could also be lots of other people. It also could be some wordsmith sitting on their bed that weights 400 pounds. Ok? If Trump Ipsum weren’t my own words, perhaps I’d be dating it. Be careful, or I will spill the beans on your placeholder text. I think the only card she has is the Lorem card. When other websites give you text, they’re not sending the best. They’re not sending you, they’re sending words that have lots of problems and they’re bringing those problems with us. They’re bringing mistakes. They’re bringing misspellings. They’re typists… And some, I assume, are good words. I have a 10 year old son. He has words. He is so good with these words it's unbelievable."
  product.price = rand(9000) + rand(900) + rand(90)

  product.user = merchant_list.sample
  product.photo_url = "https://loremflickr.com/300/300/politics?random=#{i+1}"
  successful = product.save

  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}" # so user can check that work to see what happened
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"

Product.all.each do |prod|
  a = Category.all.shuffle
  prod.categories << a.first
  prod.categories << a.last
end
