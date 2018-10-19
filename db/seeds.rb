# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

MERCHANT_FILE = Rails.root.join('db', 'seed_data', 'merchant.csv')
puts "Loading raw merchant data from #{MERCHANT_FILE}"

merchant_failures = []
CSV.foreach(MERCHANT_FILE, :headers => true) do |row|
  merchant = Merchant.new
  merchant.id = row['id']
  merchant.name = row['name']
  merchant.email = row['email']
  merchant.uid = row['uid']
  merchant.provider = row['provider']
  successful = merchant.save
  if !successful
    merchant_failures << merchant
    puts "Failed to save merchant: #{merchant.inspect}"
  else
    puts "Created merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchants failed to save"


CATEGORY_FILE = Rails.root.join('db', 'seed_data', 'category.csv')
puts "Loading raw category data from #{CATEGORY_FILE}"

category_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.id = row['id']
  category.name = row['name']
  successful = category.save
  if !successful
    category_failures << category
    puts "Failed to save category: #{category.inspect}"
  else
    puts "Created category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categories failed to save"



PRODUCT_FILE = Rails.root.join('db', 'seed_data', 'products.csv')
puts "Loading raw product data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.id = row['id']
  product.name = row['name']
  product.price = row['price']
  product.description = row['description']
  product.img_file= row['img_file']
  product.merchant_id = row['merchant_id']
  successful = product.save
  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"


category1 = Category.find(1)
products1 = Product.where(merchant_id: 1)

products1.each do |product|
    category1.products << product
end
successful = category1.save

if !successful
  puts "category1.products failed to save product."
else
  puts "category1.products successfully saved."
end



category2 = Category.find(2)
products2 = Product.where(merchant_id: 2)

products2.each do |product|
    category2.products << product
end
successful = category2.save

if !successful
  puts "category2.products failed to save product."
else
  puts "category2.products successfully saved."
end


category3 = Category.find(3)
products3 = Product.where(merchant_id: 3)

products3.each do |product|
    category3.products << product
end
successful = category3.save

if !successful
  puts "category3.products failed to save product."
else
  puts "category3.products successfully saved."
end

category4 = Category.find(4)
products4 = Product.where(merchant_id: 4)

products4.each do |product|
    category4.products << product
end
successful = category4.save

if !successful
  puts "category4.products failed to save product."
else
  puts "category4.products successfully saved."
end


category5 = Category.find(5)
products5 = Product.where(merchant_id: 5)

products5.each do |product|
    category5.products << product
end
successful = category5.save

if !successful
  puts "category5.products failed to save product."
else
  puts "category5.products successfully saved."
end


category6 = Category.find(6)
products6 = Product.where(merchant_id: 6)

products6.each do |product|
    category6.products << product
end
successful = category6.save

if !successful
  puts "category6.products failed to save product."
else
  puts "category6.products successfully saved."
end


category7 = Category.find(7)
products7 = Product.where(merchant_id: 7)

products7.each do |product|
    category7.products << product
end
successful = category7.save

if !successful
  puts "category7.products failed to save product."
else
  puts "category7.products successfully saved."
end


category8 = Category.find(8)
products8 = Product.where(merchant_id: 8)

products8.each do |product|
    category8.products << product
end
successful = category8.save

if !successful
  puts "category8.products failed to save product."
else
  puts "category8.products successfully saved."
end


# Since we set the primary key (the ID) manually on each of the
# tables, we've got to tell postgres to reload the latest ID
# values. Otherwise when we create a new record it will try
# to start at ID 1, which will be a conflict.
puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "done"
