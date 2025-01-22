require "test_helper"

class PerspectivesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_one)
    @calendar = calendars(:calendar_one)
    @post = posts(:post_one)
    @perspective = perspectives(:perspective_one)
    @socialplatform = socialplatforms(:socialplatform_one)
    sign_in @user
  end

  test "should show perspective" do
    get calendar_post_perspective_url(@calendar, @post, @perspective)
    assert_response :success
    assert_not_nil assigns(:perspectives)
    assert_not_nil assigns(:publishplatform)
  end

  test "should create perspective" do
    # First, set up a default perspective with copy if it doesn't exist
    default_perspective = @post.perspectives.create(copy: "Default Copy") unless @post.perspectives.where(socialplatform: nil).exists?

    assert_difference("Perspective.count", 1) do
      perspective_params = {
        perspective: {
          socialplatform_id: @socialplatform.id,
          copy: "Copy"
        }
      }

      post calendar_post_perspectives_url(@calendar, @post), params: perspective_params
    end

    assert_redirected_to calendar_post_perspective_path(@calendar, @post, Perspective.last)
    assert_equal "Perspective was successfully created.", flash[:notice]
  end

  test "should destroy perspective" do
    perspective = perspectives(:perspective_one)
    assert_difference("Perspective.count", -1) do
      delete calendar_post_perspective_url(@calendar, @post, perspective)
    end
  end

  test "should update perspective status" do
    patch update_status_calendar_post_perspective_url(@calendar, @post, @perspective), params: {
      perspective: { status: "approved" }
    }
    assert_redirected_to calendar_post_perspective_url(@calendar, @post, @perspective)
    assert_equal "approved", @perspective.reload.status
  end

  test "should update post status" do
    patch update_status_post_calendar_post_perspective_url(@calendar, @post, @perspective), params: {
      post: { status: "approved" }
    }
    assert_redirected_to calendar_post_perspective_url(@calendar, @post, @perspective)
    assert_equal "approved", @post.reload.status
  end

  test "should update perspective copy" do
    patch update_copy_calendar_post_perspective_url(@calendar, @post, @perspective), params: {
      perspective: { copy: "Updated Copy" }
    }
    assert_response :success
    assert_equal "Updated Copy", @perspective.reload.copy
  end
end
