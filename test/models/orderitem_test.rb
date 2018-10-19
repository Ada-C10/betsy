require "test_helper"

describe Orderitem do
  let(:orderitem) { orderitems(:itemsone) }

  it "must be valid" do
    expect(orderitem).must_be :valid?
  end

describe "validations" do
  it "requires a quantity" do
    order = orderitems(:itemsone)
    order.quantity = nil

    valid = order.save

    expect(valid).must_equal false
    expect(order.errors.messages).must_include :quantity
    expect(order.errors.messages[:quantity]).must_equal ["Cannot be blank"]
  end

  it "requires quanity to be integers"
    order_thing = Orderitem.new(quantity: 1)

    valid = order_thing.save

    valid.must_equal true
    valid.must_be_instance_of Integer
  end
end

end
