require "test_helper"

class PersoncompaniesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user = users(:user_one)
    @person = people(:person_one) 
    @personTwo = people(:person_two) 
    @company = companies(:company_one)
    @companyTwo = companies(:company_two)
    @personcompany = personcompanies(:person_companies_one)
    sign_in @user
  end

  test "should create personcompany by person" do
    assert_difference('Personcompany.count') do
      post create_by_person_personcompanies_url(@person), params: {
        personcompany: {
          company_id: @companyTwo.id,
          is_working: true,
          is_my_contact: false
        }
      }
    end
    assert_redirected_to person_path(@person)
  end

  test "should create personcompany by company" do  
    assert_difference('Personcompany.count') do
      post create_by_company_personcompanies_url(@company), params: {
        personcompany: {
          person_id: @personTwo.id,
          is_working: true, 
          is_my_contact: false
        }
      }
    end
    assert_redirected_to company_path(@company)
  end

  test "should update personcompany is_working by person" do
    patch update_is_working_by_person_personcompanies_url(@person, @company)
    assert_redirected_to person_path(@person)
    @personcompany.reload
    assert_not @personcompany.is_working
  end

  test "should update personcompany is_working by company" do
    patch update_is_working_by_company_personcompanies_url(@company, @person) 
    assert_redirected_to company_path(@company)
    @personcompany.reload
    assert_not @personcompany.is_working
  end

  test "should destroy personcompany by person" do
    assert_difference('Personcompany.count', -1) do
      delete destroy_by_person_personcompanies_url(@person, @company)
    end
    assert_redirected_to person_path(@person)
  end

  test "should destroy personcompany by company" do
    assert_difference('Personcompany.count', -1) do
      delete destroy_by_company_personcompanies_url(@company, @person)
    end
    assert_redirected_to company_path(@company) 
  end
end
