require 'faker'
require 'csv'

CSV.open('db/seed_data/merchant.csv', "w", :write_headers=> true,
  :headers => ["id", "name", "email", "uid", "provider"]) do |csv|

  csv << [1, "Sammi-Jo Lee", "sjlee3157@gmail.com", 29874466, "github"]
  csv << [2, "Shelan Debesai", "shelan@uw.edu", 25810109, "github"]
  csv << [3, "Katie Jahanmir", "katietj@gmail.com", 25754627, "github"]
  csv << [4, "Alice Hsiao", "alice.hsiao87@gmail.com", 9450062, "github"]

  3.times do |i|
    fake_user = Faker::Omniauth.github

    id = i+5
    name = fake_user[:info][:name]
    email = fake_user[:info][:email]
    uid = fake_user[:uid]

    csv << [id, name, email, uid, "github"]
  end
end

CSV.open('db/seed_data/order.csv', "w", :write_headers=> true,
  :headers => ["id", "status", "name", "address", "cc_num", "exp_date", "zip", "cvv", "email"]) do |csv|
  20.times do |i|
    id = i+1
    status = %w(pending pending pending pending paid paid paid paid complete complete complete complete cancelled).sample
    unless status == "pending"
      name = Faker::FunnyName.name
      address = Faker::Address.full_address
      cc_num = Faker::Finance.credit_card
      exp_date = "#{Faker::Stripe.month}#{Faker::Stripe.year}"
      zip = Faker::Address.zip
      cvv = Faker::Stripe.ccv
      email = Faker::Internet.free_email
    end

    csv << [id, status, name, address, cc_num, exp_date, zip, cvv, email]
  end
end


CSV.open('db/seed_data/orderitem.csv', "w", :write_headers=> true,
  :headers => ["id", "quantity", "order_id", "product_id"]) do |csv|
  50.times do |i|
    id = i+1
    quantity = rand(1..4)
    order_id = rand(1..20)
    product_id = rand(1..35)
    csv << [id, quantity, order_id, product_id]
  end
end
