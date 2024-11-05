require "test_helper"

class PersonlinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @personlink = personlinks(:one)
  end

  test "should get index" do
    get personlinks_url
    assert_response :success
  end

  test "should get new" do
    get new_personlink_url
    assert_response :success
  end

  test "should create personlink" do
    assert_difference("Personlink.count") do
      post personlinks_url, params: { personlink: { content: @personlink.content, person_id: @personlink.person_id } }
    end

    assert_redirected_to personlink_url(Personlink.last)
  end

  test "should show personlink" do
    get personlink_url(@personlink)
    assert_response :success
  end

  test "should get edit" do
    get edit_personlink_url(@personlink)
    assert_response :success
  end

  test "should update personlink" do
    patch personlink_url(@personlink), params: { personlink: { content: @personlink.content, person_id: @personlink.person_id } }
    assert_redirected_to personlink_url(@personlink)
  end

  test "should destroy personlink" do
    assert_difference("Personlink.count", -1) do
      delete personlink_url(@personlink)
    end

    assert_redirected_to personlinks_url
  end
end
