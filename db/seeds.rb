require 'csv'

MERCHANT_FILE = Rails.root.join('db', 'seed_data', 'merchant.csv')
PRODUCT_FILE = Rails.root.join('db', 'seed_data', 'product.csv')
ORDER_FILE = Rails.root.join('db', 'seed_data', 'order.csv')
ORDERITEM_FILE = Rails.root.join('db', 'seed_data', 'orderitem.csv')
CATEGORY_FILE = Rails.root.join('db', 'seed_data', 'category.csv')

#################################################################
puts "Loading raw merchant data from #{MERCHANT_FILE}"

merchant_failures = []
CSV.foreach(MERCHANT_FILE, :headers => true) do |row|
  merchant = Merchant.new
  merchant.id = row['id'].to_i
  merchant.name = row['name']
  merchant.email = row['email']
  merchant.uid = row['uid']
  merchant.provider = row['provider']
  successful = merchant.save
  if !successful
    merchant_failures << merchant
    puts "\n"
    puts "Failed to save merchant id: #{merchant.id}"
    puts "Errors: #{merchant.errors.full_messages}"
    puts "\n"
  else
    puts "Created merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchants failed to save"
puts "\n\n"

#################################################################
puts "Loading raw order data from #{CATEGORY_FILE}"

category_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.id = row['id'].to_i
  category.name = row['name']
  category.image_url = row['image_url']
  successful = category.save
  if !successful
    category_failures << category
    puts "\n"
    puts "Failed to save category id: #{category.id}"
    puts "#{category.inspect}"
    puts "Errors: #{category.errors.full_messages}"
    puts "\n"
  else
    puts "Created category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categories failed to save"

puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "done"
puts "\n\n"

#################################################################
puts "Loading raw product data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.id = row['id'].to_i
  product.name = row['name']
  product.cost = row['cost'].to_f
  product.merchant_id = row['merchant_id'].to_i
  product.inventory = row['inventory'].to_i
  product.description = row['description']
  product.image_url = row['image_url']
  product.category_ids = row['category_ids'].split(';')
  successful = product.save
  if !successful
    product_failures << product
    puts "\n"
    puts "Failed to save product id: #{product.id}"
    puts "#{product.inspect}"
    puts "Errors: #{product.errors.full_messages}"
    puts "\n"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"

puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "done"
puts "\n\n"

#################################################################
puts "Loading raw order data from #{ORDER_FILE}"

order_failures = []
CSV.foreach(ORDER_FILE, :headers => true) do |row|
  order = Order.new
  order.id = row['id'].to_i
  order.status = row['status']
  order.address = row['address']
  order.cc_num = row['cc_num']
  order.exp_date = row['exp_date']
  order.zip = row['zip']
  order.cvv = row['cvv']
  order.email = row['email']
  successful = order.save
  if !successful
    order_failures << order
    puts "\n"
    puts "Failed to save order id: #{order.id}"
    puts "#{order.inspect}"
    puts "Errors: #{order.errors.full_messages}"
    puts "\n"
  else
    puts "Created order: #{order.inspect}"
  end
end

puts "Added #{Order.count} order records"
puts "#{order_failures.length} orders failed to save"

puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "done"
puts "\n\n"

#################################################################
puts "Loading raw orderitem data from #{ORDERITEM_FILE}"

orderitem_failures = []
CSV.foreach(ORDERITEM_FILE, :headers => true) do |row|
  orderitem = Orderitem.new
  orderitem.id = row['id'].to_i
  orderitem.quantity = row['quantity'].to_i
  orderitem.order_id = row['order_id'].to_i
  orderitem.product_id = row['product_id'].to_i
  successful = orderitem.save
  if !successful
    orderitem_failures << orderitem
    puts "\n"
    puts "Failed to save orderitem id: #{orderitem.id}"
    puts "#{orderitem.inspect}"
    puts "Errors: #{orderitem.errors.full_messages}"
    puts "\n"
  else
    puts "Created orderitem: #{orderitem.inspect}"
  end
end

puts "Added #{Orderitem.count} orderitem records"
puts "#{orderitem_failures.length} orderitems failed to save"

puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "done"
puts "\n\n"
