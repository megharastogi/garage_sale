require 'test_helper'

class ForgotPasswordControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get change_password" do
    get :change_password
    assert_response :success
  end

  test "should get update_password" do
    get :update_password
    assert_response :success
  end

end
