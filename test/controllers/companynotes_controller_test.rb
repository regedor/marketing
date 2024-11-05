require "test_helper"

class CompanynotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @companynote = companynotes(:one)
  end

  test "should get index" do
    get companynotes_url
    assert_response :success
  end

  test "should get new" do
    get new_companynote_url
    assert_response :success
  end

  test "should create companynote" do
    assert_difference("Companynote.count") do
      post companynotes_url, params: { companynote: { company_id: @companynote.company_id, note: @companynote.note, user_id: @companynote.user_id } }
    end

    assert_redirected_to companynote_url(Companynote.last)
  end

  test "should show companynote" do
    get companynote_url(@companynote)
    assert_response :success
  end

  test "should get edit" do
    get edit_companynote_url(@companynote)
    assert_response :success
  end

  test "should update companynote" do
    patch companynote_url(@companynote), params: { companynote: { company_id: @companynote.company_id, note: @companynote.note, user_id: @companynote.user_id } }
    assert_redirected_to companynote_url(@companynote)
  end

  test "should destroy companynote" do
    assert_difference("Companynote.count", -1) do
      delete companynote_url(@companynote)
    end

    assert_redirected_to companynotes_url
  end
end
