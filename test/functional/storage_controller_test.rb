require 'test_helper'

class StorageControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get remove" do
    get :remove
    assert_response :success
  end

end
