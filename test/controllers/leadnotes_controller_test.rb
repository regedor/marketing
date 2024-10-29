require "test_helper"

class LeadnotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @leadnote = leadnotes(:one)
  end

  test "should get index" do
    get leadnotes_url
    assert_response :success
  end

  test "should get new" do
    get new_leadnote_url
    assert_response :success
  end

  test "should create leadnote" do
    assert_difference("Leadnote.count") do
      post leadnotes_url, params: { leadnote: { lead_id: @leadnote.lead_id, note: @leadnote.note, user_id: @leadnote.user_id } }
    end

    assert_redirected_to leadnote_url(Leadnote.last)
  end

  test "should show leadnote" do
    get leadnote_url(@leadnote)
    assert_response :success
  end

  test "should get edit" do
    get edit_leadnote_url(@leadnote)
    assert_response :success
  end

  test "should update leadnote" do
    patch leadnote_url(@leadnote), params: { leadnote: { lead_id: @leadnote.lead_id, note: @leadnote.note, user_id: @leadnote.user_id } }
    assert_redirected_to leadnote_url(@leadnote)
  end

  test "should destroy leadnote" do
    assert_difference("Leadnote.count", -1) do
      delete leadnote_url(@leadnote)
    end

    assert_redirected_to leadnotes_url
  end
end
