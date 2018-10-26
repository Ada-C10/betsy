require "test_helper"

describe Merchant do

  before do
    @ironchef = merchants(:iron_chef)
  end

  it "must be valid" do
    Merchant.all.each do |m|
      expect(m.valid?).must_equal true
    end
  end


  describe "merchant model reltionship" do

    it "merchant has a reltionship to order items through products" do

      expect(@ironchef.order_items.last.product.name).must_equal "Taco"
      expect(@ironchef.order_items.first.product.name).must_equal "Thyme"
      expect(@ironchef.id).must_equal  @ironchef.products.first.merchant_id
      expect(@ironchef.id).must_equal  @ironchef.products.last.merchant_id
    end


    it "merchant has many products" do

      thyme = products(:thyme)
      taco = products(:taco)

      @ironchef.must_respond_to :products

      @ironchef.products.each do |product|
        product.must_be_kind_of Product
      end
    end



    it "merchant has relationship with order items" do
      order_item = order_items(:order_item_6)

      thyme = products(:thyme)
      taco = products(:taco)

      @ironchef.must_respond_to :order_items
    end
  end


  describe "merchant model validation checks" do

    it "requires a name and an email" do
      merchant = Merchant.new(uid: 19, provider: 'github')
      merchant.valid?.must_equal false
      merchant.errors.messages.must_include :name
      merchant.errors.messages.must_include :email
    end

    it "requires a unique name" do
      merchant1 = Merchant.new(name: @ironchef.name, email: "someone@gmail.com" )

      merchant1.valid?.must_equal false

      merchant1.errors.messages.must_include :name
    end


    it "requires unique email" do
      merchant2 = Merchant.new(name: "someone", email: @ironchef.email )

      merchant2.valid?.must_equal false

      merchant2.errors.messages.must_include :email
    end


    it "Passes when name is present and is unique" do
      valid_merchant = Merchant.new(name: "DanDeeLions", email: "dandeelions@gmail.com" )

      valid_merchant.valid?.must_equal true
    end

    it "Passes when email is present and unique" do
      valid_merchant = Merchant.new(name: "Email", email: "email@gmail.com" )

      valid_merchant.valid?.must_equal true
    end
  end

  describe "calculates accurate data" do

    before do
      order1 = order_items(:order_item_6)
      order2 = order_items(:order_item_5)
    end

    it "merchant order total method return accurate price for two orders " do

      @ironchef.order_items.length.must_equal 2
      expect(@ironchef.order_total).must_equal 3000
    end

    it "returns right tax based on a order item " do

      expect(@ironchef.order_total).must_equal 3000
      expect(@ironchef.tax).must_equal 300

    end


    it "returns right total with taxes" do
      expect(@ironchef.order_total).must_equal 3000
      expect(@ironchef.tax).must_equal 300
      expect(@ironchef.total_tax).must_equal 3300
    end
  end
end
