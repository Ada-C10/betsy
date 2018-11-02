require "test_helper"

describe Product do
  let(:product) { products(:shirt) }
  let(:product2) {products(:dress)}
  let(:product3) {products(:mumu)}
  let(:user) { users(:user1) }
  let(:category1) {categories(:category1)}
  let(:category2) {categories(:category2)}
  before do
    product.categories << category1
    product.categories << category2
  end

  it "must be valid" do
      expect(product).must_be :valid?
    end

  it 'has required fields' do
    fields = [:name, :user_id, :stock, :price, :status]

    fields.each do |field|
      expect(product).must_respond_to field
    end
  end

  describe 'Relationships' do
    it 'belongs to an user' do

      user = product.user

      expect(user).must_be_instance_of Merchant
      expect(user.id).must_equal product.user_id
    end

end

  describe "validations" do
    it "requires a name" do
      product.name = nil
      product.valid?.must_equal false
      product.errors.messages.must_include :name
    end



    it "requires a user_id" do
      product.user_id = nil
      product.valid?.must_equal false
      product.errors.messages.must_include :user_id
    end



    it "reject a invalid stock value" do
      product.stock = nil
      product.valid?.must_equal false
      product.errors.messages.must_include :stock
    end


    it " stock value cannot be negative" do
      product.stock = -1
      product.valid?.must_equal false

    end

    it " stock value can be 0" do
      last = Product.all.count

      prod2 = Product.new(name: "Polo shirt")
      prod2.user = user
      prod2.stock = 0
      prod2.price = 5
      prod2.categories << category2

      prod2.save!
      expect(Product.all.count).must_equal last+1
    end

    it "it only accept integers as stock quantity" do
      product.stock = 2.1

      product.valid?.must_equal false

    end

    it "reject invalid price" do
      product.price = nil
      product.valid?.must_equal false
      product.errors.messages.must_include :price
    end

    it "accept 0 price" do
      last = Product.all.count

      prod2 = Product.new(name: "Polo shirt")
      prod2.user = user
      prod2.stock = 0
      prod2.price = 0
      prod2.categories << category2

      prod2.save!
      expect(Product.all.count).must_equal last+1
    end
  end


  describe "active_products" do
    it "returns an array" do
      products = Product.active_products
      expect(products).must_be_instance_of Array
    end

    it "returns an empty array if no active products" do
      Product.all.each do |product|
        product.status = false
        product.save
      end

      expect(Product.active_products.empty?).must_equal true
    end

    it "returns an array of product" do
      expect(Product.active_products.first).must_be_kind_of Product
    end

    it "The array length will be added by 1 for a newly created product" do
      prod2 = Product.new(name: "Polo shirt")
      prod2.user = user
      prod2.stock = 2
      prod2.price = 1
      prod2.categories << category2
      count = Product.active_products.length
      prod2.save!

      expect(Product.active_products.length).must_equal count+1

    end

    it "The array will include all the valid product" do
      expect(Product.active_products.first).must_equal product
      expect(Product.active_products[1]).must_equal product2

    end
  end


  describe "self.category_list" do

    it "returns an array of correct product " do
      list1 = Product.category_list(category1.id)

      expect(list1.count).must_equal 1

      list1.each do |prod|
        prod.must_be_kind_of Product
        prod.categories.must_include category1
      end
    end

    it "returns an empty array if no product in that category" do
      category3 = Category.new(name:"outdoor")
      list2 = Product.category_list(category3.id)

      expect(list2.empty?).must_equal true
    end
  end

  describe "self.by_merchant" do
    before do
      @user2 = User.create(
        name: "jas",
        uid: 89076544,
        provider: "github"
      )
      @user2.type = "Merchant"
      @user2.save

      @id = product.user_id

    end

    it "returns an array of correct product " do
      list1 = Product.merchant_list(@id)
      expect(list1.count).must_equal 3

      expect(list1.first).must_be_kind_of Product
      expect(list1.first.user_id).must_equal @id

    end

    it "returns an empty array if no product in that merchant" do
      list2 = Product.merchant_list(@user2.id)
      expect(list2.empty?).must_equal true
    end
  end
end
