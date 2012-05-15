require 'test_helper'

class AboutUsControllerTest < ActionController::TestCase
  test "should get terms_of_use" do
    get :terms_of_use
    assert_response :success
  end

  test "should get privacy_policy" do
    get :privacy_policy
    assert_response :success
  end

end
