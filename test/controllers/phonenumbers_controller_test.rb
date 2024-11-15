require "test_helper"

class PhonenumbersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @person = people(:person_one)
    @other_person = people(:person_two)
    @phonenumber = phonenumbers(:phonenumber_one)
    @user = users(:user_one)
    sign_in @user
  end

  test "should create phonenumber" do
    assert_difference('Phonenumber.count') do
      post person_phonenumbers_path(@person), params: {
        phonenumber: { 
          number: "1234567890",
          current: true,
          is_active: true
        }
      }
    end
    assert_redirected_to person_path(@person)
    assert_equal "Phonenumber was successfully created.", flash[:notice]
  end

  test "should not create phonenumber with invalid data" do
    assert_no_difference('Phonenumber.count') do
      post person_phonenumbers_path(@person), params: {
        phonenumber: { number: "" }
      }
    end
    assert_redirected_to person_path(@person)
    assert_match /Failed to create phonenumber/, flash[:alert]
  end

  test "should update phonenumber" do
    patch person_phonenumber_path(@person, @phonenumber), params: {
      phonenumber: { number: "9876543210" }
    }
    assert_redirected_to person_path(@person)
    assert_equal "Phonenumber was successfully updated.", flash[:notice]
  end

  test "should not update phonenumber with invalid data" do
    patch person_phonenumber_path(@person, @phonenumber), params: {
      phonenumber: { number: "" }
    }
    assert_response :unprocessable_entity
  end

  test "should destroy phonenumber" do
    assert_difference('Phonenumber.count', -1) do
      delete person_phonenumber_path(@person, @phonenumber)
    end
    assert_redirected_to person_path(@person)
    assert_equal "Phonenumber was successfully deleted.", flash[:notice]
  end

  test "should not allow access from different organization" do
    @user.update(organization: organizations(:organization_two))
    post person_phonenumbers_path(@person), params: {
      phonenumber: { number: "1234567890" }
    }
    assert_redirected_to root_path
    assert_equal "Access Denied", flash[:alert]
  end

  test "should redirect when not authenticated" do
    sign_out @user
    post person_phonenumbers_path(@person), params: {
      phonenumber: { number: "1234567890" }
    }
    assert_redirected_to new_user_session_path
  end
end