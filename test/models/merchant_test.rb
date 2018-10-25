require "test_helper"

describe Merchant do

  before do
    @ironchef = merchants(:iron_chef)
  end

  # this was just to test that table data was valid
  it "must be valid" do
    Merchant.all.each do |m|
      expect(m.valid?).must_equal true
    end
  end



  it "merchant has many products" do

    thyme = products(:thyme)
    taco = products(:taco)

    @ironchef.must_respond_to :products

    @ironchef.products.each do |product|
      product.must_be_kind_of Product
    end
  end




  it "merchant has many products" do

    thyme = products(:thyme)
    taco = products(:taco)

    @ironchef.must_respond_to :products

    @ironchef.products.each do |product|
      product.must_be_kind_of Product
    end
  end


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
