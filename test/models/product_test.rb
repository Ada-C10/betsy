require "test_helper"
describe Product do
  let(:product) { products(:product1) }

  it "must be valid" do
    expect(product).must_be :valid?
  end

  it "must have required fields" do
    fields = [:name, :price, :description, :photo, :stock]

    fields.each do |field|
      expect(product).must_respond_to field
    end
  end

  describe 'Relationships' do
    it 'belongs to user' do
      user = product.user

      expect(user).must_be_instance_of User
      expect(user.id).must_equal product.user_id
    end

    it 'can have many categories' do
      product.categories << Category.first
      categories = product.categories

      expect(categories.length).must_be :>=, 1
      categories.each do |category|
        expect(category).must_be_instance_of Category
      end

    end

    it 'can have many orders' do

      orders = product.orders

      expect(orders.length).must_be :>=, 1
      orders.each do |order|
        expect(order).must_be_instance_of Order
      end
    end
  end

  describe 'Validations' do
    it 'must have name' do
      product = products(:product2)
      product.name = nil

      valid = product.save
      expect(valid).must_equal false
      expect(product.errors.messages).must_include :name
    end

    it 'must have a unique product name for given merchant' do
      product1 = products(:product1)
      product3 = products(:product3)
      product3.name = product1.name

      valid = product3.save
      expect(valid).must_equal false
      expect(product3.errors.messages).must_include :name
    end

    it 'different merchants can have the same product name' do
      product1 = products(:product1)
      product2 = products(:product2)
      product2.name = product1.name

      valid = product2.save
      expect(valid).must_equal true

    end

    it 'must have price' do
      product = products(:product2)
      product.price = nil

      valid = product.save
      expect(valid).must_equal false
      expect(product.errors.messages).must_include :price
    end

    it 'must have a number greater than 0 for price' do
      invalid_prices = ["s", :price, "134e", nil, -1]
      product = products(:product1)

      invalid_prices.each do |invalid_price|
        product.price = invalid_price
        valid = product.save
        expect(valid).must_equal false
        expect(product.errors.messages).must_include :price
      end
    end

    it 'must have description' do
      product = products(:product2)
      product.description = nil

      valid = product.save
      expect(valid).must_equal false
      expect(product.errors.messages).must_include :description
    end

    it 'must have photo' do
      product = products(:product2)
      product.photo = nil

      valid = product.save
      expect(valid).must_equal false
      expect(product.errors.messages).must_include :photo
    end

    it 'must have a valid stock' do
      product = products(:product2)
      invalid_stocks = ["s", :price, "134e", nil, -1]

      invalid_stocks.each do |stock|
        product.stock = stock
        valid = product.save
        expect(valid).must_equal false
        expect(product.errors.messages).must_include :stock
      end
    end

  end

  describe 'Custom Methods' do
    it 'must create a list of unique categories' do
      category_list = Product.category_list
      category_list.each do |category|
        expect(Category.all).must_include category
      end
    end

    it 'can reduce stock when there is enough stock' do
      stock_check = product.stock
      product.reduce_stock(1)
      expect(product.stock).must_equal stock_check - 1

    end

    it 'will not reduce stock if there is not enough' do
      product.reduce_stock(5)
      valid = product.save
      expect(valid).must_equal false
      expect(product.errors.messages).must_include :stock
    end

  end

  describe 'Can add product to cart?' do
    it 'returns true if stock is availble to fill order' do
      #arrange
      product = products(:product2)
      quantity = product.stock - 1
      #act
      result = product.can_purchase?(quantity)
      #assert
      expect(result).must_equal true
    end

    it 'returns false if stock is unavailable to fill order' do
      #arrange
      product = products(:product2)
      quantity = product.stock + 1
      #act
      result = product.can_purchase?(quantity)
      #assert
      expect(result).must_equal false

    end
    it "returns true if stock is equal to requested quantity" do
      #arrange
      product = products(:product2)
      quantity = product.stock
      #act
      result = product.can_purchase?(quantity)
      #assert
      expect(result).must_equal true
    end
  end

end
