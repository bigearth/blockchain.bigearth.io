require 'test_helper'

class AppsControllerTest < ActionController::TestCase
  test "should get bookmarks" do
    get :bookmarks
    assert_response :success
  end
  
  test "should get calculator" do
    get :calculator
    assert_response :success
  end
end
