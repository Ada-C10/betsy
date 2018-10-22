require "test_helper"

describe Order do
  let(:ciara) { orders(:ordciara) }
  let(:legend) { orders(:ordlegend) }
  let(:russell) { orders(:ordrussell) }
  let(:future) { orders(:ordfuture) }



  describe "Custom Methods" do


    describe "Total Cost Method" do
      it "will calculate total cost of order" do
        total_cost = ciara.total_cost

        expect(total_cost).must_equal 6404.0
      end
    end
  end

  valid_statuses = ['pending', 'cancelled', 'complete', 'paid']

  describe "validations" do

    it "must be valid" do
      expect(ciara.valid?).must_equal true
    end

    it "must have a status" do
      ciara.status = nil
      ciara.valid?.must_equal false
      expect(ciara.errors.messages).must_include :status
    end

    it "must have a valid status" do
      ciara.status = "done"
      legend.status = "paid"
      russell.status = "cancelled"
      future.status = "complete"

      ciara.valid?.must_equal false
      legend.valid?.must_equal true
      russell.valid?.must_equal true
      future.valid?.must_equal true

      expect(ciara.errors.messages).must_include :status
    end
  end

  it "requires a name" do
    ciara.name = nil
    ciara.valid?.must_equal false
    expect(ciara.errors.messages).must_include :name
    expect(ciara.errors.messages[:name]).must_equal ["can't be blank"]
  end

  it "requires an email" do
    ciara.email = nil
    valid = ciara.save
    expect(valid).must_equal false
    expect(ciara.errors.messages).must_include :email
    expect(ciara.errors.messages[:email]).must_equal ["can't be blank"]
  end

  it "requires an address" do
    legend.address = nil
    valid = legend.save
    expect(valid).must_equal false
    expect(legend.errors.messages).must_include :address
  end

  it "requires a credit card number" do
    legend.cc_num = nil
    valid = legend.save
    expect(valid).must_equal false
    expect(legend.errors.messages).must_include :cc_num
    expect(legend.errors.messages[:cc_num]).must_equal ["can't be blank"]
  end

  it "requires a ccv" do
    legend.cvv = nil
    valid = legend.save
    expect(valid).must_equal false
    expect(legend.errors.messages).must_include :cvv
  end



  it "requires an expiration date" do
    legend.exp_date = nil
    valid = legend.save
    expect(valid).must_equal false
    expect(legend.errors.messages).must_include :exp_date
  end



  it "requires a zip code" do
    legend.zip = nil
    valid = legend.save
    expect(valid).must_equal false
    expect(legend.errors.messages).must_include :zip
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
