require 'test_helper'

class BlocksControllerTest < ActionController::TestCase
  test "should get show" do
    get :show, id: '404687'
    assert_response :success
  end
  
  test "should get transactions" do
    request.headers["Accept"] = "application/json"
    get :transactions, id: '404687'
    assert_response :success
  end
  
  test "should get raw" do
    request.headers["Accept"] = "application/json"
    get :raw, id: '404687'
    assert_response :success
  end
end
