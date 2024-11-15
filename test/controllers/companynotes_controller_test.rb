require "test_helper"
class CompanynotesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @company = companies(:company_one)
    @other_company = companies(:company_two)
    @user = users(:user_one) 
    @note = companynotes(:company_one_note_one)
    sign_in @user
  end

  test "should create companynote" do
    assert_difference('Companynote.count') do
      post company_companynotes_path(@company), params: { 
        companynote: { note: "Test note" }
      }
    end
    assert_redirected_to company_path(@company)
    assert_equal "Note was successfully created.", flash[:notice]
  end

  test "should not create invalid companynote" do
    assert_no_difference('Companynote.count') do
      post company_companynotes_path(@company), params: {
        companynote: { note: "" }
      }
    end
    assert_match /Failed to create note/, flash[:alert]
  end

  test "should get edit" do
    get edit_company_companynote_path(@company, @note)
    assert_response :success
  end

  test "should update companynote" do
    patch company_companynote_path(@company, @note), params: {
      companynote: { note: "Updated note" }
    }
    assert_redirected_to company_path(@company)
    assert_equal "Note was successfully updated.", flash[:notice]
  end

  test "should not update invalid companynote" do
    patch company_companynote_path(@company, @note), params: {
      companynote: { note: "" }
    }
    assert_response :unprocessable_entity
  end

  test "should destroy companynote as leader" do
    @user.update(isLeader: true)
    assert_difference('Companynote.count', -1) do
      delete company_companynote_path(@company, @note)
    end
    assert_redirected_to company_path(@company)
    assert_equal "Note was successfully deleted.", flash[:notice]
  end

  test "should not destroy companynote as non-author non-leader" do
    @other_note = companynotes(:company_one_note_two)
    @other_note.update(user: users(:user_two))
    delete company_companynote_path(@company, @other_note)
    assert_redirected_to root_path
    assert_equal "Access Denied", flash[:alert]
  end

  test "should not allow access from different organization" do
    get edit_company_companynote_path(@other_company, @note)
    assert_redirected_to root_path
    assert_equal "Access Denied", flash[:alert]
  end
end
