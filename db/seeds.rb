# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create(
#[
#  { name: 'Star Wars' },
#  { name: 'Lord of the Rings' }
#  ]
#)
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

#loading constants
USER_FILE = Rails.root.join('db', 'user_seeds.csv')
puts "Loading raw  data from #{USER_FILE}"


ITEM_FILE = Rails.root.join('db', 'item_seeds.csv')
puts "Loading raw  data from #{ITEM_FILE}"


#############################################################
#seeding categories
x = ["accessories", "books", "clothing", "seasonal", "luggage", "shoes", "tech", "miscellaneous"]
x.each do |category|
  Category.create(category_type: category)
end
##############################################################

##############################################################
#seeding users
user_failures = []
CSV.foreach(USER_FILE, :headers => true) do |row|

  user = User.new
  user.name = row['name']
  user.nickname = row['nickname']
  user.email = row['email']
  user.image_url = row['image_url']
  user.uid = row['uid']
  user.provider = row['provider']
  successful = user.save
  if !successful
    user_failures << user
    puts "Failed to save user: #{user.inspect}"
  else
    puts "Created user: #{user.inspect}"
  end
end
##############################################################


#Seeding items

item_failures = []
CSV.foreach(ITEM_FILE, :headers => true) do |row|

  item = Item.new
  item.price = row['price']
  item.image = row['image']
  item.quantity_available = row['quantity_available']
  item.name  = row['name']
  item.description = row['description']
  item.avg_rating = row['provider']
  item.user_id = row['user_id']
  item.active = row['active']
  item.category_id = row['category_id']

  successful = item.save
  if !successful
    item_failures << item
    puts "Failed to save item: #{item.inspect}"
  else
    puts "Created item: #{item.inspect}"
  end
end
