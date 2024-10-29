require "test_helper"

class PersonnotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @personnote = personnotes(:one)
  end

  test "should get index" do
    get personnotes_url
    assert_response :success
  end

  test "should get new" do
    get new_personnote_url
    assert_response :success
  end

  test "should create personnote" do
    assert_difference("Personnote.count") do
      post personnotes_url, params: { personnote: { note: @personnote.note, person_id: @personnote.person_id, user_id: @personnote.user_id } }
    end

    assert_redirected_to personnote_url(Personnote.last)
  end

  test "should show personnote" do
    get personnote_url(@personnote)
    assert_response :success
  end

  test "should get edit" do
    get edit_personnote_url(@personnote)
    assert_response :success
  end

  test "should update personnote" do
    patch personnote_url(@personnote), params: { personnote: { note: @personnote.note, person_id: @personnote.person_id, user_id: @personnote.user_id } }
    assert_redirected_to personnote_url(@personnote)
  end

  test "should destroy personnote" do
    assert_difference("Personnote.count", -1) do
      delete personnote_url(@personnote)
    end

    assert_redirected_to personnotes_url
  end
end
