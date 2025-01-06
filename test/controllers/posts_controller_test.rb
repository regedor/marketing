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

  test "should destroy post" do
    assert_difference("Post.count", -1) do
      delete calendar_post_url(@post.calendar_id, @post.id)
    end
    assert_redirected_to calendars_path
  end

  test "should update design idea" do
    patch update_design_idea_calendar_post_url(@calendar, @post), params: { post: { design_idea: "New Design Idea" } }
    assert_response :success
    @post.reload
    assert_equal "New Design Idea", @post.design_idea
  end

  test "should update categories" do
    patch update_categories_calendar_post_url(@calendar, @post), params: { post: { categories: [ "new_category1", "new_category2" ] } }
    assert_response :success
    @post.reload
    assert_equal [ "new_category1", "new_category2" ], @post.categories
  end

  test "should update day" do
    new_date = (Date.today + 1).to_s
    patch update_day_calendar_post_url(@calendar, @post), params: { date: new_date }
    assert_response :success
    @post.reload
    assert_equal new_date, @post.publish_date.strftime("%Y-%m-%d")
  end

  test "should update date time" do
    new_date = (Date.today + 1).to_s
    patch update_date_time_calendar_post_url(@calendar, @post), params: { datetime: new_date.to_s }
    assert_response :success
    @post.reload
    assert_equal new_date, @post.publish_date.strftime("%Y-%m-%d")
  end
end
