require "test_helper"

describe Guest do
  let(:guest) { Guest.new }

  it "must be valid" do
    value(guest).must_be :valid?
  end
end
