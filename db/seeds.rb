require 'csv'

MERCHANT_FILE = Rails.root.join('db', 'seed_data', 'merchants.csv')
puts "Loading raw merchant data from #{MERCHANT_FILE}"

merchant_failures = []

CSV.foreach(MERCHANT_FILE, :headers => true) do |row|
  merchant = Merchant.new
  merchant.id = row['id']
  merchant.username = row['username']
  merchant.email = row['email']
  merchant.uid = row['uid']
  merchant.provider = row['provider']

  successful = merchant.save
  if !successful
    merchant_failures << merchant
  puts "Failed to save merchants: #{merchant.inspect}"

  else
    puts "Created merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchants failed to save"



CATEGORY_FILE = Rails.root.join('db', 'seed_data', 'categories.csv')
puts "Loading raw category data from #{CATEGORY_FILE}"

category_failures = []

CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.name = row['name']

  successful = category.save
  if !successful
    category_failures << category
  puts "Failed to save categories: #{category.inspect}"

  else
    puts "Created category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categories failed to save"


PRODUCTS_FILE = Rails.root.join('db', 'seed_data', 'products.csv')
puts "Loading raw product data from #{PRODUCTS_FILE}"

product_failures = []

CSV.foreach(PRODUCTS_FILE, :headers => true) do |row|
  product = Product.new

  product.name = row['name']
  product.price = row['price']
  product.inventory = row['inventory']
  product.description = row['description']
  product.image = row['image']
  product.merchant_id = Merchant.all.sample.id
  product.categories << Category.all.sample(rand(1..3))


  successful = product.save
  if !successful
    product_failures << product
  puts "Failed to save product: #{product.inspect}"

  else
    puts "Created products: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"


ORDERS_FILE = Rails.root.join('db', 'seed_data', 'orders.csv')
puts "Loading raw order data from #{ORDERS_FILE}"

order_failures = []

CSV.foreach(ORDERS_FILE, :headers => true) do |row|
  order = Order.new
  order.email = row['email']
  order.mailing_address = row['mailing_address']
  order.cc = row['cc']
  order.cc_name = row['cc_name']
  order.cc_expiration = row['cc_expiration']
  order.cvv = row['cvv']
  order.zip = row['zip']
  order.status = row['status']

  successful = order.save
  if !successful
    order_failures << order
  puts "Failed to save order: #{order.inspect}"

  else
    puts "Created orders: #{order.inspect}"
  end
end

puts "Added #{Order.count} order records"
puts "#{order_failures.length} orders failed to save"



# ORDERITEMS_FILE = Rails.root.join('db', 'seed_data', 'order_items.csv')
# puts "Loading raw order item data from #{ORDERITEMS_FILE}"

order_items_failures = []

# random_orders = []
# random_orders << Order.where.not(status:'cart')
random_orders = Order.all.sample(5)

random_orders.each do |order|
  sample_products = Product.all.sample(rand(1..5))
  sample_products.each do |product|
    order_item = OrderItem.new
    order_item.order_id = order.id
    order_item.product_id = product.id
    order_item.quantity = rand(1...10)
    order_item.status = case order.status
                        when "cart"; "pending"
                        when "paid"; "paid"
                        when "completed"; "shipped"
                        end
    successful = order_item.save

    if !successful
      order_items_failures << order_item
      puts "Failed to save order_items: #{order_item.inspect}"

    else
      puts "Created order_item: #{order_item.inspect}"
    end

  end
end


REVIEWS_FILE = Rails.root.join('db', 'seed_data', 'reviews.csv')
puts "Loading raw review data from #{REVIEWS_FILE}"

review_failures = []

CSV.foreach(REVIEWS_FILE, :headers => true) do |row|
  review = Review.new
  review.rating = row['rating']
  review.description = row['description']
  review.product_id = (Product.all.sample).id


  successful = review.save
  if !successful
    review_failures << review
  puts "Failed to save reviews: #{review.inspect}"

  else
    puts "Created reviews: #{review.inspect}"
  end
end

puts "Added #{Review.count} review records"
puts "#{review_failures.length} reviews failed to save"
