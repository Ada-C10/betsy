require "test_helper"

describe Category do
  let(:category) {categories(:category1)}
  let(:category2) {categories(:category2)}

  it "must be valid" do
    expect(category).must_be :valid?
  end


it 'has required fields' do
  fields = [:name]

  fields.each do |field|
    expect(category).must_respond_to field
  end
end

describe 'Relationships' do

  it 'can have many products' do
    # Arrange, did with let

    # Act
    category.products << Product.first
    products = category.products

    # Assert
    expect(products.length).must_be :>=, 1
    products.each do |prod|
      expect(prod).must_be_instance_of Product
    end
  end
end

describe 'validations' do
  it 'must have a name' do
    # Arrange

    category.name = nil


    valid = category.save

    # Assert
    expect(valid).must_equal false
    expect(category.errors.messages).must_include :name
    expect(category.errors.messages[:name]).must_equal ["can't be blank"]
  end


  it 'requires a unique name' do

    category2.name = category.name

    valid = category2.valid?

    expect(valid).must_equal false
    expect(category2.errors.messages).must_include :name
  end
end
end
