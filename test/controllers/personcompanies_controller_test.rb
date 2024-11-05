require "test_helper"

class PersoncompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @personcompany = personcompanies(:one)
  end

  test "should get index" do
    get personcompanies_url
    assert_response :success
  end

  test "should get new" do
    get new_personcompany_url
    assert_response :success
  end

  test "should create personcompany" do
    assert_difference("Personcompany.count") do
      post personcompanies_url, params: { personcompany: { company_id: @personcompany.company_id, is_working: @personcompany.is_working, person_id: @personcompany.person_id } }
    end

    assert_redirected_to personcompany_url(Personcompany.last)
  end

  test "should show personcompany" do
    get personcompany_url(@personcompany)
    assert_response :success
  end

  test "should get edit" do
    get edit_personcompany_url(@personcompany)
    assert_response :success
  end

  test "should update personcompany" do
    patch personcompany_url(@personcompany), params: { personcompany: { company_id: @personcompany.company_id, is_working: @personcompany.is_working, person_id: @personcompany.person_id } }
    assert_redirected_to personcompany_url(@personcompany)
  end

  test "should destroy personcompany" do
    assert_difference("Personcompany.count", -1) do
      delete personcompany_url(@personcompany)
    end

    assert_redirected_to personcompanies_url
  end
end
