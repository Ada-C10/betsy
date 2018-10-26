require "test_helper"
require 'pry'

describe MerchantsHelper do

describe "render_date" do
  it "should correctly format dates to string format" do
    order = order_items.first
    expect(order.valid?).must_equal true

    date = order.created_at

    expect(render_date(order.created_at)).must_be_kind_of String
    end
  end

end
