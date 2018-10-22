require "test_helper"

describe Category do
  let(:category) { categories(:bags) }

  it "must be valid" do
    expect(category).must_be :valid?
  end

  describe "validations" do

    it "requires a name" do
      category = categories(:bags)
      category.name = nil

      valid = category.save
      expect(valid).must_equal false
      expect(category.errors.messages).must_include :name
      expect(category.errors.messages[:name]).must_equal ["can't be blank"]
    end
  end




  end


end
