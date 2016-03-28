require 'test_helper'

class AddressesControllerTest < ActionController::TestCase
  test "should get show" do
    get :show, id: '152f1muMCNa7goXYhYAQC61hxEgGacmncB'
    assert_response :success
  end
  
  test "should get balance" do
    request.headers["Accept"] = "application/json"
    get :balance, id: '152f1muMCNa7goXYhYAQC61hxEgGacmncB'
    assert_response :success
  end
  
  test "should get unspent" do
    request.headers["Accept"] = "application/json"
    get :unspent, id: '152f1muMCNa7goXYhYAQC61hxEgGacmncB'
    assert_response :success
  end
end
