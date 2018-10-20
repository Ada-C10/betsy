require "test_helper"

describe Order do

  describe "Custom Methods" do
    let(:order) { orders(:ordciara) }

    describe "Total Cost Method" do
      it "will calculate total cost of order" do
        total_cost = order.total_cost

        expect(total_cost).must_equal 6404.0
      end
    end
  end
end


describe "relations" do

  it "has a list of order items" do
      ordlegend = orders(:ordlegend)
      ordlegend.must_respond_to :orderitems
        ordlegend.orderitems.each do |orderitem|
        orderitem.must_be_kind_of Orderitem
       end
    end

    it "has a list of products" do
      ordlegend = orders(:ordlegend)
      ordlegend.must_respond_to :products
      ordlegend.products.each do |product|
      product.must_be_kind_of Product
      end
    end

end
 end
