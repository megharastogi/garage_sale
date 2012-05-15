require 'test_helper'

class SalesControllerTest < ActionController::TestCase
  setup do
    @sale = sales(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sale" do
    assert_difference('Sale.count') do
      post :create, :sale => @sale.attributes
    end

    assert_redirected_to sale_path(assigns(:sale))
  end

  test "should show sale" do
    get :show, :id => @sale.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @sale.to_param
    assert_response :success
  end

  test "should update sale" do
    put :update, :id => @sale.to_param, :sale => @sale.attributes
    assert_redirected_to sale_path(assigns(:sale))
  end

  test "should destroy sale" do
    assert_difference('Sale.count', -1) do
      delete :destroy, :id => @sale.to_param
    end

    assert_redirected_to sales_path
  end
end
