require "test_helper"

class EmailsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @person_one = people(:person_one)
    @person_two = people(:person_two)
    @email_one = emails(:email_one)
    @email_two = emails(:email_two)
    sign_in users(:user_one)
  end

  test "should create email" do
    assert_difference('Email.count') do
      post person_emails_url(@person_one), params: { email: { email: 'newemail@example.com', current: true, is_active: false } }
    end
    assert_redirected_to person_path(@person_one)
  end

  test "should not create email with invalid data" do
    assert_no_difference('Email.count') do
      post person_emails_url(@person_one), params: { email: { email: '', current: true, is_active: false } }
    end
    assert_redirected_to person_path(@person_one)
  end

  test "should update email" do
    patch person_email_url(@person_one, @email_one), params: { email: { email: 'updatedemail@example.com' } }
    assert_redirected_to person_path(@person_one)
  end

  test "should not update email with invalid data" do
    patch person_email_url(@person_one, @email_one), params: { email: { email: '' } }
    assert_response :unprocessable_entity
  end

  test "should destroy email" do
    assert_difference('Email.count', -1) do
      delete person_email_url(@person_one, @email_one)
    end
    assert_redirected_to person_path(@person_one)
  end
end