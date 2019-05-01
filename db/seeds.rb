# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'
USER_FILE = Rails.root.join('db', 'user_seeds.csv')
puts "Loading raw review data from #{USER_FILE}"

user_failures = []
CSV.foreach(USER_FILE, :headers => true) do |row|
  user = User.new
  user.uid = row['uid']
  user.username = row['username']
  user.email = row['email']
  successful = user.save
  if !successful
    user_failures << user
    puts "Failed to save user: #{user.inspect}"
    puts "Error: #{user.errors}"
  else
    puts "Created user: #{user.inspect}"
  end
end

puts "Added #{User.count} user records"
puts "#{user_failures.length} user failed to save"



PRODUCT_FILE = Rails.root.join('db', 'product_seeds.csv')
puts "Loading raw review data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.prod_name = row['prod_name']
  product.user_id = row['user_id']
  product.description = row['description']
  product.price =  row['price']
  product.inv_qty = row['inv_qty']
  product.active = row['active']
  product.image = row['image']
  successful = product.save
  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
    puts "Error: #{product.errors}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} product failed to save"

ORDER_FILE = Rails.root.join('db', 'order_seeds.csv')
puts "Loading raw order data from #{ORDER_FILE}"

order_failures = []
CSV.foreach(ORDER_FILE, :headers => true) do |row|
  order = Order.new
  order.status = row['status']
  order.cust_name = row['cust_name']
  order.cust_email = row['cust_email']
  order.mailing_address = row['mailing_address']
  order.cc_name = row['cc_name']
  order.cc_digit = row['cc_digit']
  order.cc_expiration = row['cc_expiration']
  order.cc_cvv = row['cc_cvv']
  order.cc_zip = row['cc_zip']
  successful = order.save
  if !successful
    order_failures << order
    puts "Failed to save order: #{order.inspect}"
    puts "Error: #{order.errors}"
  else
    puts "Created order: #{order.inspect}"
  end
end

puts "Added #{Order.count} order records"
puts "#{order_failures.length} order failed to save"





REVIEW_FILE = Rails.root.join('db', 'review_seeds.csv')
puts "Loading raw review data from #{REVIEW_FILE}"

review_failures = []
CSV.foreach(REVIEW_FILE, :headers => true) do |row|
  review = Review.new
  review.rating = row['rating']
  review.description = row['description']
  review.product_id = row['product_id']
  successful = review.save
  if !successful
    review_failures << review
    puts "Failed to save review: #{review.inspect}"
    puts "Error: #{review.errors}"
  else
    puts "Created review: #{review.inspect}"
  end
end

puts "Added #{Review.count} review records"
puts "#{review_failures.length} review failed to save"




#Populate order_items table

# OrderItem.create(order_id: 2, product_id: 1, qty: 1, shipped: false)
# add 3 items to first order
# Order.first.order_items << Product.sample(3)
# #


CATEGORY_FILE = Rails.root.join('db', 'category_seeds.csv')
puts "Loading raw review data from #{REVIEW_FILE}"

category_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.category = row['category']

  successful = category.save
  if !successful
    category_failures << category
    puts "Failed to save category: #{category.inspect}"
    puts "Error: #{category.errors}"
  else
    puts "Created category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} category failed to save"


Product.all.each do |product|
  product.categories << Category.first
end


OrderStatus.delete_all
OrderStatus.create! id: 1, name: "In Progress"
OrderStatus.create! id: 2, name: "Placed"
OrderStatus.create! id: 3, name: "Shipped"
OrderStatus.create! id: 4, name: "Cancelled"
