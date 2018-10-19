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
  end
end

end
