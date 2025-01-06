require "test_helper"

class Dashboard::UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_one)
    @leader = users(:user_two)
    @organization = organizations(:organization_one)
  end

  test "should get new" do
    sign_in @leader
    get new_dashboard_user_path
    assert_response :success
  end

  test "should create user" do
    sign_in @leader
    assert_difference("User.count") do
      post dashboard_users_path, params: { user: { email: "newuser@example.com", organization_id: @organization.id, isLeader: false } }
    end
  end

  test "should get edit" do
    sign_in @leader
    get edit_dashboard_user_path(@user)
    assert_response :success
  end

  test "should update user" do
    sign_in @leader
    patch dashboard_user_path(@user), params: { user: { email: "updated@example.com" } }
    @user.reload
    assert_equal "updated@example.com", @user.email
  end

  # test "should destroy user" do
  #   sign_in @leader
  #   assert_difference('User.count', -1) do
  #     delete dashboard_user_path(@user)
  #   end
  #   assert_redirected_to dashboard_path
  # end

  test "should redirect new when not logged in" do
    get new_dashboard_user_path
    assert_redirected_to new_user_session_path
  end

  test "should redirect create when not logged in" do
    post dashboard_users_path, params: { user: { email: "newuser@example.com", organization_id: @organization.id, isLeader: false } }
    assert_redirected_to new_user_session_path
  end

  test "should redirect edit when not logged in" do
    get edit_dashboard_user_path(@user)
    assert_redirected_to new_user_session_path
  end

  test "should redirect update when not logged in" do
    patch dashboard_user_path(@user), params: { user: { email: "updated@example.com" } }
    assert_redirected_to new_user_session_path
  end

  test "should redirect destroy when not logged in" do
    delete dashboard_user_path(@user)
    assert_redirected_to new_user_session_path
  end

  test "should redirect new when not a leader" do
    sign_in @user
    get new_dashboard_user_path
    assert_redirected_to root_path
    assert_equal "Access Denied", flash[:alert]
  end

  test "should redirect create when not a leader" do
    sign_in @user
    post dashboard_users_path, params: { user: { email: "newuser@example.com", organization_id: @organization.id, isLeader: false } }
    assert_redirected_to root_path
    assert_equal "Access Denied", flash[:alert]
  end

  test "should redirect edit when not a leader" do
    sign_in @user
    get edit_dashboard_user_path(@user)
    assert_redirected_to root_path
    assert_equal "Access Denied", flash[:alert]
  end

  test "should redirect update when not a leader" do
    sign_in @user
    patch dashboard_user_path(@user), params: { user: { email: "updated@example.com" } }
    assert_redirected_to root_path
    assert_equal "Access Denied", flash[:alert]
  end

  test "should redirect destroy when not a leader" do
    sign_in @user
    delete dashboard_user_path(@user)
    assert_redirected_to root_path
    assert_equal "Access Denied", flash[:alert]
  end
end
