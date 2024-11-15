class PersonnotesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user = users(:user_one)
    @person = people(:person_one)
    @note = personnotes(:person_one_note_one)
    sign_in @user
  end

  test "should create personnote" do
    assert_difference('Personnote.count') do
      post person_personnotes_path(@person), params: {
        personnote: { note: "Test note" }
      }
    end
    assert_redirected_to person_path(@person)
    assert_equal "Note was successfully created.", flash[:notice]
  end

  test "should not create invalid personnote" do
    assert_no_difference('Personnote.count') do
      post person_personnotes_path(@person), params: {
        personnote: { note: "" }
      }
    end
    assert_match /Failed to create note/, flash[:alert]
  end

  test "should get edit" do
    get edit_person_personnote_path(@person, @note)
    assert_response :success
  end

  test "should update personnote" do
    patch person_personnote_path(@person, @note), params: {
      personnote: { note: "Updated note" }
    }
    assert_redirected_to person_path(@person)
    assert_equal "Note was successfully updated.", flash[:notice]
  end

  test "should not update invalid personnote" do
    patch person_personnote_path(@person, @note), params: {
      personnote: { note: "" }
    }
    assert_response :unprocessable_entity
  end

  test "should destroy personnote as leader" do
    @user.update(isLeader: true)
    assert_difference('Personnote.count', -1) do
      delete person_personnote_path(@person, @note)
    end
    assert_redirected_to person_path(@person)
    assert_equal "Note was successfully deleted.", flash[:notice]
  end

  test "should not allow access from different organization" do
    @user.update(organization: organizations(:organization_two))
    get edit_person_personnote_path(@person, @note)
    assert_redirected_to root_path
    assert_equal "Access Denied", flash[:alert]
  end
end