require "test_helper"

describe Order do
  # pull from fixtures
  let(:guest) { guests(:legend) }
  let(:order) { orders(:ordlegend) }

  it "must be valid" do
    expect(order).must_be :valid?
  end

describe Order do

  describe "validations" do
    it "must have the one of the four valid statuses" do
      valid_statuses = ['pending', 'cancelled', 'complete', 'paid']
      valid_statuses.each do |status|
        order = Order.new(guest: guest, status: status)
        order.valid?.must_equal true
      end
    end

describe Guest do
  let(:guest) { guests(:legend) }

  it "must be valid" do
    expect(guest).must_be :valid?
  end

it "requires a name" do
  guest.name = nil

  valid = guest.save

  expect(valid).must_equal false
  expect(guest.errors.messages).must_include :name
  expect(guest.errors.messages[:name]).must_equal ["can't be blank"]
end

it "requires an email" do
  guest_two = guest
  guest_two.email = nil

  valid = guest_two.save

  expect(valid).must_equal false
  expect(guest_two.errors.messages).must_include :email
  expect(guest_two.errors.messages[:email]).must_equal ["can't be blank"]
end

it "requires an address" do
  guest_order = guest
  guest_order.address = "133rd 15th St Seattle, WA"

  valid = guest_order.save

  expect(valid).must_equal true
end

it "requires a credit card number" do
  guest.cc_num = nil

  valid = guest.save

  expect(valid).must_equal false
  expect(guest.errors.messages).must_include :cc_num
  expect(guest.errors.messages[:cc_num]).must_equal ["can't be blank"]
end

it "requires ccv to contain 3 to 4 integers" do
  guest_two = guest
  guest_two.cvv = 232

  valid = guest_two.save

  expect(valid).must_equal true
  expect(valid.length).must_equal 2..3
end
#
# it "requires an expiration date"
#   # date.parse
#   order = guests(:ordrussell)
#   order.exp_date = Date.parse(2018-10-17)
#
#   valid = order.save
#
#   expect(valid).must_equal true
# end
#
# it "rejects expiration dates set in the past"
#
#   new_order = Order.new exp_date: Date.parse(2016-10-17)
#
#   new_order.valid?
#
#   expect(new_order).must_equal false
#   expect(new_order.errors.messages).must_include :cvv
#   expect(new_order.errors.messages[:exp_date]).must_equal ["Must not have an expired credit card date"]
# end
#
# it "requires a zip code"
#   guest = guests(:ordlegend)
#   guest.zip = 98122
#
#   valid = guests.save
#
#   expect(valid).must_equal true
# end
end
