require "test_helper"

class TeamsUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @teams_user = teams_users(:one)
  end

  test "should get index" do
    get teams_users_url
    assert_response :success
  end

  test "should get new" do
    get new_teams_user_url
    assert_response :success
  end

  test "should create teams_user" do
    assert_difference("TeamsUser.count") do
      post teams_users_url, params: { teams_user: { team_id: @teams_user.team_id, user_id: @teams_user.user_id } }
    end

    assert_redirected_to teams_user_url(TeamsUser.last)
  end

  test "should show teams_user" do
    get teams_user_url(@teams_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_teams_user_url(@teams_user)
    assert_response :success
  end

  test "should update teams_user" do
    patch teams_user_url(@teams_user), params: { teams_user: { team_id: @teams_user.team_id, user_id: @teams_user.user_id } }
    assert_redirected_to teams_user_url(@teams_user)
  end

  test "should destroy teams_user" do
    assert_difference("TeamsUser.count", -1) do
      delete teams_user_url(@teams_user)
    end

    assert_redirected_to teams_users_url
  end
end
