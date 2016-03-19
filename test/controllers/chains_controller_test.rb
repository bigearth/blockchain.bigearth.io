require 'test_helper'

class ChainsControllerTest < ActionController::TestCase
  setup do
    @chain = chains(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:chains)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create chain" do
    assert_difference('Chain.count') do
      post :create, chain: { pub_key: @chain.pub_key }
    end

    assert_redirected_to chain_path(assigns(:chain))
  end

  test "should show chain" do
    get :show, id: @chain
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @chain
    assert_response :success
  end

  test "should update chain" do
    patch :update, id: @chain, chain: { pub_key: @chain.pub_key }
    assert_redirected_to chain_path(assigns(:chain))
  end

  test "should destroy chain" do
    assert_difference('Chain.count', -1) do
      delete :destroy, id: @chain
    end

    assert_redirected_to chains_path
  end
end
