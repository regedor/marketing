require "test_helper"

class PublishplatformsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @publishplatform = publishplatforms(:one)
  end

  test "should get index" do
    get publishplatforms_url
    assert_response :success
  end

  test "should get new" do
    get new_publishplatform_url
    assert_response :success
  end

  test "should create publishplatform" do
    assert_difference("Publishplatform.count") do
      post publishplatforms_url, params: { publishplatform: { post_id: @publishplatform.post_id, social_platform: @publishplatform.social_platform } }
    end

    assert_redirected_to publishplatform_url(Publishplatform.last)
  end

  test "should show publishplatform" do
    get publishplatform_url(@publishplatform)
    assert_response :success
  end

  test "should get edit" do
    get edit_publishplatform_url(@publishplatform)
    assert_response :success
  end

  test "should update publishplatform" do
    patch publishplatform_url(@publishplatform), params: { publishplatform: { post_id: @publishplatform.post_id, social_platform: @publishplatform.social_platform } }
    assert_redirected_to publishplatform_url(@publishplatform)
  end

  test "should destroy publishplatform" do
    assert_difference("Publishplatform.count", -1) do
      delete publishplatform_url(@publishplatform)
    end

    assert_redirected_to publishplatforms_url
  end
end
