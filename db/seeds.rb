# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

USER_FILE = Rails.root.join('db', 'user_seeds.csv')

user_failures = []
CSV.foreach(USER_FILE, :headers => true) do |row|
  user = User.new
  user.name = row['name']
  user.email = row['email']
  user.uid = row['uid']
  user.provider = row['provider']
  successful = user.save
  if !successful
    user_failures << user
  else
    puts "User created: #{user.inspect}"
  end
end

CATEGORY_FILE = Rails.root.join('db', 'category_seeds.csv')
category_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.name = row['name']
  successful = category.save
  if !successful
    category_failures << category
  else
    puts "Category created: #{category.inspect}"
  end
end

ORDER_FILE = Rails.root.join('db', 'order_seeds.csv')
order_failures = []
CSV.foreach(ORDER_FILE, :headers => true) do |row|
  order = Order.new
  order.name = row['name']
  order.email = row['email']
  order.mailing_address = row['mailing_address']
  order.zip_code = row['zip_code']
  order.cc_number = row['cc_number']
  order.cc_expiration = row['cc_expiration']
  order.cc_cvv = row['cc_cvv']
  order.status = row['status']
  order.total_cost = row['total_cost']
  successful = order.save
  if !successful
    order_failures << order
    puts order_failures
    puts order.errors.messages
  else
    puts "Order created: #{order.inspect}"
  end
end

CREATURE_FILE = Rails.root.join('db', 'creature_seeds.csv')

creature_failures = []
CSV.foreach(CREATURE_FILE, :headers => true) do |row|
  creature = Product.new
  creature.name = row['name']
  creature.stock_count = row['stock_count']
  creature.description = row['description']
  creature.price = row['price']
  creature.photo_url = row['photo_url']
  category = Category.where(name: row['category'])
    creature.categories << category
  ids = User.pluck(:id)
  random_record = User.find(ids.sample)
    creature.user_id = random_record.id
  # ids = Category.pluck(:id)
  # random_record = Category.find(ids.sample)
  #   creature.category_id = random_record.id
  successful = creature.save
    if !successful
      creature_failures << creature
    else
      #puts "Creature created: #{creature.inspect}"
    end
end
