require "test_helper"

describe Order do
  let(:order) { orders(:ordciara) }

  it "must be valid" do
    expect(order).must_be :valid?
  end
end

describe "validations" do
  it "requires a status" do
    order = orders(:ordciara)
    order.status = nil

    valid = order.save

    expect(valid).must_equal false
    expect(order.errors.messages).must_include :status
    expect(order.errors.messages[:status]).must_equal ["Cannot be blank"]
  end

  it "requires a name"
    order = orders(:ordrussell)
    order.name = "russell"

    valid = order.save

    expect(valid).must_equal true
  end

  it "requires an email"
    order_two = orders(:ordrussell)
    order_two.email = nil

    valid = order_two.save

    expect(valid).must_equal false
    expect(order_two.errors.messages).must_include :email
    expect(order_two.errors.messages[:email]).must_equal ["Cannot be blank"]
  end

  it "requires an address"
    fun_order = orders(:ordlegend)
    fun_order.address = "133rd 15th St Seattle, WA"

    valid = fun_order.save

    expect(valid).must_equal true
  end

  it "requires a credit card number"
    order_europe = orders(:ordciara)
    order_europe.cc_num = nil

    valid = order_europe.save

    expect(valid).must_equal false
    expect(order.errors.messages).must_include :cc_num
    expect(order.errors.messages[:cc_num]).must_equal ["Must have a credit card number"]
  end

  it "only accepts integers for a credit card"
    order = orders(:ordlegend)
    order.cc_num = 1238475869584736

    expect(order).must_be_instance_of Integer
  end

  it "requires a credit card to contain 16 integers"
    order = orders(:ordciara)
    order.cc_num = 1238225869584736

    valid = order.save

    expect(valid).must_equal true
    expect(valid.length).must_equal 16
  end

  it "rejects credit card that does not contain 16 integers"
    order = orders(:ordciara)
    order.cc_num = 12382

    valid = order.save

    expect(valid.length).must_equal false
    expect(order.errors.messages).must_include :cc_num
    expect(order.errors.messages[:cc_num]).must_equal ["Credit card must have 16 numbers"]
  end

  it "requires cvv number"
    order = orders(:ordciara)
    order.cvv = nil

    valid = order.save

    expect(valid).must_equal false
    expect(order.errors.messages).must_include :cvv
    expect(order.errors.messages[:cvv]).must_equal ["Cannot be blank"]
  end

  it "requires ccv to contain 3 to 4 integers"
    order = orders(:ordlegend)
    order.cvv = 232

    valid = order.save

    expect(valid).must_equal true
    expect(valid.length).must_equal (2..3)
  end

  it "requires an expiration date"
    # date.parse
    order = orders(:ordrussell)
    order.exp_date = Date.parse(2018-10-17)

    valid = order.save

    expect(valid).must_equal true
  end

  it "rejects expiration dates set in the past"

    new_order = Order.new exp_date: Date.parse(2016-10-17)

    new_order.valid?

    expect(new_order).must_equal false
    expect(new_order.errors.messages).must_include :cvv
    expect(new_order.errors.messages[:exp_date]).must_equal ["Must not have an expired credit card date"]
  end

  it "requires a zip code"
    order = orders(:ordlegend)
    order.zip = 98122

    valid = order.save

    expect(valid).must_equal true
  end
end
    #
    #
    # ORDER DOES NOT HAVE A COlUMN!!
    # it "only allows the three valid statuses" do
    #   valid_statuses = ['pending', 'paid', 'complete', 'cancelled']
    #
    #   valid_statuses.each do |status|
    #     order = Order.new(status: status)
    #     order.valid?.must_equal true
    #   end
    # end
    #
    # it "rejects invalid statuses"
    #   invalid_statuses = ['failed', 'yes', $, 1337, nil] do
    #
    #   invalid_statuses.each do |status|
    #     order = Order.new(status: status)
    #     order.valid?.must_equal false
    #   end
