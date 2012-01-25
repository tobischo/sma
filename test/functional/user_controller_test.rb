require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should get settings" do
    get :settings
    assert_response :success
  end

  test "should get changepassword" do
    get :changepassword
    assert_response :success
  end

end
