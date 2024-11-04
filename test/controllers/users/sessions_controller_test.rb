require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should respond to JSON format" do
    get new_user_session_url, as: :json
    assert_response :success
    assert_equal "application/json; charset=utf-8", @response.content_type
  end

  test "should respond to HTML format" do
    get new_user_session_url, as: :html
    assert_response :success
    assert_equal "text/html; charset=utf-8", @response.content_type
  end

  test "should inherit from Devise::SessionsController" do
    assert Users::SessionsController < Devise::SessionsController
  end
end
