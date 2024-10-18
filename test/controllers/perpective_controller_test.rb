require 'test_helper'

class PerspectivesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @calendar = calendars(:calendar_one)
    @post = posts(:post_one)
    @perspective = perspectives(:perspective_one)
    @user = users(:user_one)
    @socialplatform = socialplatforms(:socialplatform_one)
    sign_in @user
  end

  test "should show perspective" do
    get calendar_post_perspective_url(@calendar, @post, @perspective)
    assert_response :success
  end

  test "should get new" do
    get new_calendar_post_perspective_url(@calendar, @post)
    assert_response :success
  end

  test "should create perspective" do
    assert_difference('Perspective.count') do
      post calendar_post_perspectives_url(@calendar, @post), params: { perspective: { copy: 'New Perspective', socialplatform_id: @socialplatform.id } }
    end
    assert_redirected_to calendar_post_perspective_url(@calendar, @post, Perspective.last)
  end

  test "should not create perspective with invalid data" do
    assert_no_difference('Perspective.count') do
      post calendar_post_perspectives_url(@calendar, @post), params: { perspective: { copy: '' } }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_calendar_post_perspective_url(@calendar, @post, @perspective)
    assert_response :success
  end
  
  test "should update perspective" do
    patch calendar_post_perspective_url(@calendar, @post, @perspective), params: { perspective: { copy: 'Updated Perspective', socialplatform_id: @socialplatform.id } }
    assert_redirected_to calendar_post_perspective_url(@calendar, @post, @perspective)
  end

  test "should not update perspective with invalid data" do
    patch calendar_post_perspective_url(@calendar, @post, @perspective), params: { perspective: { copy: ''} }
    assert_response :unprocessable_entity
  end

  test "should destroy perspective" do
    assert_difference('Perspective.count', -1) do
      delete calendar_post_perspective_url(@calendar, @post, @perspective)
    end
    assert_redirected_to calendar_post_url(@calendar, @post)
  end

  test "should approve perspective" do
    patch approved_calendar_post_perspective_url(@calendar, @post, @perspective)
    @perspective.reload
    assert_equal "approved", @perspective.status
    assert_redirected_to calendar_post_perspective_url(@calendar, @post, @perspective)
  end

  test "should set perspective in analysis" do
    patch in_analysis_calendar_post_perspective_url(@calendar, @post, @perspective)
    @perspective.reload
    assert_equal "in_analysis", @perspective.status
    assert_redirected_to calendar_post_perspective_url(@calendar, @post, @perspective)
  end

  test "should reject perspective" do
    patch rejected_calendar_post_perspective_url(@calendar, @post, @perspective)
    @perspective.reload
    assert_equal "rejected", @perspective.status
    assert_redirected_to calendar_post_perspective_url(@calendar, @post, @perspective)
  end

  test "should download perspective attachments" do
    get download_calendar_post_perspective_url(@calendar, @post, @perspective)
    assert_response :success
  end
end