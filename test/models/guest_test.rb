require "test_helper"

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
  expect(guest.errors.messages[:cc_num]).must_equal ["Must have a credit card number"]
end
#
# it "only accepts integers for a credit card"
#   order = guests(:ordlegend)
#   order.cc_num = 1238475869584736
#
#   expect(order).must_be_instance_of Integer
# end
#
# it "requires a credit card to contain 16 integers"
#   order = guests(:ordciara)
#   order.cc_num = 1238225869584736
#
#   valid = order.save
#
#   expect(valid).must_equal true
#   expect(valid.length).must_equal 16
# end
#
# it "rejects credit card that does not contain 16 integers"
#   order = guests(:ordciara)
#   order.cc_num = 12382
#
#   valid = order.save
#
#   expect(valid.length).must_equal false
#   expect(order.errors.messages).must_include :cc_num
#   expect(order.errors.messages[:cc_num]).must_equal ["Credit card must have 16 numbers"]
# end
#
# it "requires cvv number"
#   order = guests(:ordciara)
#   order.cvv = nil
#
#   valid = order.save
#
#   expect(valid).must_equal false
#   expect(order.errors.messages).must_include :cvv
#   expect(order.errors.messages[:cvv]).must_equal ["Cannot be blank"]
# end
#
# it "requires ccv to contain 3 to 4 integers"
#   guest = guests(:ordlegend)
#   guest.cvv = 232
#
#   valid = guest.save
#
#   expect(valid).must_equal true
#   expect(valid.length).must_equal (2..3)
# end
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
