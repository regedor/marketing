require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index if authenticated" do
    user = users(:user_one)
    sign_in user
    get root_url
    assert_response :success
  end

  test "should redirect to login if not authenticated" do
    get root_url
    assert_redirected_to new_user_session_path
  end
end
