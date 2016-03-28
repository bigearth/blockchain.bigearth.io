require 'test_helper'

class TransactionsControllerTest < ActionController::TestCase
  test "should show transaction" do
    get :show, id: '3e97420233b8c7409c06d9abceb5eb2c62d7638b7bac54a42693c08692b245cf'
    assert_response :success
  end
  
  test "should get raw" do
    request.headers["Accept"] = "application/json"
    get :raw, id: '3e97420233b8c7409c06d9abceb5eb2c62d7638b7bac54a42693c08692b245cf'
    assert_response :success
  end
end
