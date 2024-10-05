require "application_system_test_case"

class TeamsUsersTest < ApplicationSystemTestCase
  setup do
    @teams_user = teams_users(:one)
  end

  test "visiting the index" do
    visit teams_users_url
    assert_selector "h1", text: "Teams users"
  end

  test "should create teams user" do
    visit teams_users_url
    click_on "New teams user"

    fill_in "Team", with: @teams_user.team_id
    fill_in "User", with: @teams_user.user_id
    click_on "Create Teams user"

    assert_text "Teams user was successfully created"
    click_on "Back"
  end

  test "should update Teams user" do
    visit teams_user_url(@teams_user)
    click_on "Edit this teams user", match: :first

    fill_in "Team", with: @teams_user.team_id
    fill_in "User", with: @teams_user.user_id
    click_on "Update Teams user"

    assert_text "Teams user was successfully updated"
    click_on "Back"
  end

  test "should destroy Teams user" do
    visit teams_user_url(@teams_user)
    click_on "Destroy this teams user", match: :first

    assert_text "Teams user was successfully destroyed"
  end
end
