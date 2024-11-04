require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_one)
    @leader = users(:user_two)
    @organization = organizations(:organization_one)
  end

  test "should redirect index when not logged in" do
    get dashboard_path
    assert_redirected_to new_user_session_path
  end

  test "should redirect index when not a leader" do
    sign_in @user
    get dashboard_path
    assert_redirected_to root_path
    assert_equal "Access Denied", flash[:alert]
  end

  test "should get index when logged in as leader" do
    sign_in @leader
    get dashboard_path
    assert_response :success
  end
end
