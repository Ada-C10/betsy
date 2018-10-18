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

cate_list = ["book", "movie","album","furnitue","appliance"]

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

user_name_list = ["lily", "Jessy", "Mary", "Michael", "Frank","Susan"]

user_failures = []

user_name_list.each do |nam|

  user = User.new
  user.name = nam
  successful = user.save
  if !successful
    user_failures << user
    puts "Failed to save user: #{user.inspect}" # so user can check that work to see what happened
  else
    puts "Created user: #{user.inspect}"
  end
end

puts "Added #{User.count} user records"
puts "#{user_failures.length} users failed to save"

product_failures = []

5.times do |i|
  category = Category.find(i+1)
  user = User.find(i+1)
  product_name = Faker::Name.name
  product = Product.new
  product.name = product_name
  product.stock = 10
  product.description = "just a test"
  product.price = 100
  product.category = category
  product.user = user
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
