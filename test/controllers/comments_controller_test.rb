require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @calendar = calendars(:calendar_one)
    @post = posts(:post_one)
    @comment = comments(:comment_one)
    @user = users(:user_one)
    sign_in @user
  end

  test "should create comment" do
    assert_difference("Comment.count") do
      post calendar_post_comments_url(@calendar, @post), params: { comment: { content: "New Comment" } }
    end
    assert_redirected_to calendar_post_path(@calendar, @post, anchor: dom_id(Comment.last))
  end

  test "should not create comment with invalid data" do
    assert_no_difference("Comment.count") do
      post calendar_post_comments_url(@calendar, @post), params: { comment: { content: "" } }
    end
    assert_redirected_to calendar_post_path(@calendar, @post, anchor: "comments_info")
  end

  test "should get edit" do
    get edit_calendar_post_comment_url(@calendar, @post, @comment)
    assert_response :success
  end

  test "should update comment" do
    patch calendar_post_comment_url(@calendar, @post, @comment), params: { comment: { content: "Updated Comment" } }
    assert_redirected_to calendar_post_path(@calendar, @post, anchor: dom_id(@comment))
  end

  test "should not update comment with invalid data" do
    patch calendar_post_comment_url(@calendar, @post, @comment), params: { comment: { content: "" } }
    assert_response :unprocessable_entity
  end

  test "should destroy comment" do
    assert_difference("Comment.count", -1) do
      delete calendar_post_comment_url(@calendar, @post, @comment)
    end
  end
end
