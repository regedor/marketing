require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @calendar = calendars(:calendar_one)
    @post = posts(:post_one)
    @user = users(:user_one)
    sign_in @user
  end

  test "should get show" do
    get calendar_post_url(@calendar, @post)
    assert_redirected_to calendars_path()
  end

  test "should get new" do
    get new_calendar_post_url(@calendar)
    assert_response :success
  end
  
  test "should create post" do
    assert_difference("Post.count") do
      post_params = {
        title: "Title",
        design_idea: "Design Idea",
        categories: "category1,category2",
        publish_date: Date.today,
        perspectives_attributes: {
          "0" => {
            copy: "Copy"
          }
        }
      }
      post calendar_posts_url(@calendar), params: { post: post_params }

    end
    assert_redirected_to calendar_post_url(@calendar, Post.last)
  end

  test "should update post" do
    post_params = {
      title: "Title",
      design_idea: "Design Idea",
      categories: "category1,category2",
      status: "approved",
      publish_date: Date.today,
      perspectives_attributes: {
        "0" => {
          copy: "Copy"
        }
      }
    }
    patch calendar_post_url(@calendar, @post), params: { post: post_params }
    assert_redirected_to calendar_post_url(@calendar, @post)
  end

  test "should get edit" do
    get edit_calendar_post_url(@calendar, @post)
    assert_response :success
  end

  # test "should destroy post" do
  #   assert_difference("Post.count", -1) do
  #     delete calendar_post_url(@post.calendar_id, @post.id)
  #   end
  #   assert_redirected_to calendars_path
  # end

  # test "should approve post" do
  #   patch approved_calendar_post_url(@calendar, @post)
  #   assert_redirected_to calendar_post_url(@calendar, @post)
  #   @post.reload
  #   assert_equal "approved", @post.status
  # end

  # test "should set post in analysis" do
  #   patch in_analysis_calendar_post_path(@calendar, @post)
  #   assert_redirected_to calendar_post_path(@calendar, @post)
  #   @post.reload
  #   assert_equal "in_analysis", @post.status
  # end

  # test "should reject post" do
  #   patch rejected_calendar_post_url(@calendar, @post)
  #   assert_redirected_to calendar_post_url(@calendar, @post)
  #   @post.reload
  #   assert_equal "rejected", @post.status
  # end
end
