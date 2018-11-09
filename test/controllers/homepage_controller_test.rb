require "test_helper"

describe HomepageController do
  it 'should get index' do
    get root_path
    must_respond_with :success
  end
end
