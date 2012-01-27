require 'test_helper'

class ConnectionControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get remove" do
    get :remove
    assert_response :success
  end

  test "should get add" do
    get :add
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

end
