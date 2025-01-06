require "test_helper"

class PublishplatformsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_one)
    @other_user = users(:user_two)
    @calendar = calendars(:calendar_one)
    @post = posts(:post_one)
    @socialplatform = socialplatforms(:socialplatform_one)
    @socialplatform_two = socialplatforms(:socialplatform_two)
    @publishplatform = publishplatforms(:publishplatform_one)
    sign_in @user
  end

  test "should create publishplatform when user is author" do
    assert_difference("Publishplatform.count") do
      post calendar_post_publishplatforms_path(@calendar, @post), params: {
        publishplatform: { socialplatform_id: @socialplatform_two.id }
      }
    end

    assert_response :success
    assert_equal "Publishplatform created successfully", JSON.parse(response.body)["message"]
  end

  test "should not create publishplatform when user is not author" do
    sign_in @other_user

    assert_no_difference("Publishplatform.count") do
      post calendar_post_publishplatforms_path(@calendar, @post), params: {
        publishplatform: { socialplatform_id: @socialplatform.id }
      }
    end

    assert_response :forbidden
    assert_equal "You are not the author", JSON.parse(response.body)["error"]
  end

  test "should not create publishplatform when user is not in organization" do
    @user.update(organization: organizations(:organization_two))

    assert_no_difference("Publishplatform.count") do
      post calendar_post_publishplatforms_path(@calendar, @post), params: {
        publishplatform: { socialplatform_id: @socialplatform.id }
      }
    end

    assert_response :forbidden
    assert_equal "You are not part of this organization", JSON.parse(response.body)["error"]
  end

  test "should destroy publishplatform when user is author" do
    assert_difference("Publishplatform.count", -1) do
      delete calendar_post_publishplatform_path(@calendar, @post, @socialplatform)
    end

    assert_response :success
    assert_equal "Publishplatform deleted successfully", JSON.parse(response.body)["message"]
  end

  test "should not destroy publishplatform when user is not author" do
    sign_in @other_user

    assert_no_difference("Publishplatform.count") do
      delete calendar_post_publishplatform_path(@calendar, @post, @socialplatform)
    end

    assert_response :forbidden
    assert_equal "You are not the author", JSON.parse(response.body)["error"]
  end

  test "should not destroy publishplatform when user is not in organization" do
    @user.update(organization: organizations(:organization_two))

    assert_no_difference("Publishplatform.count") do
      delete calendar_post_publishplatform_path(@calendar, @post, @socialplatform)
    end

    assert_response :forbidden
    assert_equal "You are not part of this organization", JSON.parse(response.body)["error"]
  end
end
