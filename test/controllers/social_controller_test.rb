require "test_helper"

class SocialControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get social_index_url
    assert_response :success
  end
end
