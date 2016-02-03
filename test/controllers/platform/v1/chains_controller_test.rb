require 'test_helper'

class Platform::V1::ChainsControllerTest < ActionController::TestCase
  setup do
    @platform_v1_chain = platform_v1_chains(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:platform_v1_chains)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create platform_v1_chain" do
    assert_difference('Platform::V1::Chain.count') do
      post :create, platform_v1_chain: { pub_key: @platform_v1_chain.pub_key }
    end

    assert_redirected_to platform_v1_chain_path(assigns(:platform_v1_chain))
  end

  test "should show platform_v1_chain" do
    get :show, id: @platform_v1_chain
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @platform_v1_chain
    assert_response :success
  end

  test "should update platform_v1_chain" do
    patch :update, id: @platform_v1_chain, platform_v1_chain: { pub_key: @platform_v1_chain.pub_key }
    assert_redirected_to platform_v1_chain_path(assigns(:platform_v1_chain))
  end

  test "should destroy platform_v1_chain" do
    assert_difference('Platform::V1::Chain.count', -1) do
      delete :destroy, id: @platform_v1_chain
    end

    assert_redirected_to platform_v1_chains_path
  end
end
