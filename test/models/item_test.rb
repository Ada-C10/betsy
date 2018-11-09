require "test_helper"

describe Item do


  #relation tests: an order has many items, a category has many items

  describe 'relations' do

    it 'an item belongs to a category' do

      category = Item.first.category

      expect category.must_be_kind_of Category
    end

    it 'an item belongs to a user' do

      user = Item.first.user
      expect user.must_be_kind_of User
    end

  end

  describe 'validations' do

    before do
      @user_one = Item.first.user
      @category_one = Category.first
      @category_two = Category.first

      # no name
      @nameless_item = Item.new(
        name: nil,
        category: @category_one,
        price: 40,
        quantity_available: 2,
        user: @user_one

      )
      # no price
      @priceless_item = Item.new(
        name: 'no price',
        category: @category_one,
        price: nil,
        quantity_available: 3,
        user: @user_one

      )
      # no quantitiy
      @quantityless_item = Item.new(
        name: 'no quantitiy',
        category: @category_one,
        price: 30,
        quantity_available: nil,
        user: @user_one
      )
      # same name, same qty, same category (duplicate)

      @thing_one = Item.new(
        name: 'twin',
        category: @category_one,
        price: 30,
        quantity_available: 2,
        user: @user_one
      )

      @thing_two = Item.new(
        name: 'twin',
        category: @category_one,
        price: 30,
        quantity_available: 2,
        user: @user_one
      )

      # same everything diff category is valid

      @same_name_diff_cat = Item.new(
        name: 'cat',
        category: Category.first,
        price: 30,
        quantity_available: 3,
        user: @user_one
      )

      @diff_cat = Item.new(
        name: 'cat',
        category: Category.first,
        price: 30,
        quantity_available: 3,
        user: @user_one
      )
    end

    it 'is valid when title, category, and price is present' do
      @valid_item = Item.first
      is_valid = @valid_item.valid?
      expect( is_valid ).must_equal true

    end

    it 'is not valid without a name' do
      is_valid = @nameless_item.valid?
      expect( is_valid ).must_equal false

    end

    it 'is not valid without a price' do
      is_valid = @priceless_item.valid?
      expect( is_valid ).must_equal false
    end

    it 'is not valid without a quantitiy' do
      is_valid = @quantityless_item.valid?
      expect( is_valid ).must_equal false
    end

    # it 'is not valid with same name, quantity, and price' do
    #   is_valid = @thing_two.valid?
    #   expect( is_valid ).must_equal false
    # end

    it 'is valid with same name, diff category' do
      is_valid = @same_name_diff_cat.valid?
      expect ( is_valid ).must_equal true

    end
  end

  describe 'decrement_quantity_available(num)' do

    it 'will decrement quantity in instance of item by num' do
      valid_item = Item.first

      starting_quant = valid_item.quantity_available
      num = 1

      valid_item.decrement_quantity_available(num)
      ending_quant = valid_item.quantity_available

      expect(ending_quant).must_equal starting_quant - num
    end

    it 'will not decrement quantity in instance of item if num is nil' do

      valid_item = Item.first

      starting_quant = valid_item.quantity_available
      num = nil

      valid_item.decrement_quantity_available(num)
      ending_quant = valid_item.quantity_available

      expect(ending_quant).must_equal starting_quant
    end


  end
end
