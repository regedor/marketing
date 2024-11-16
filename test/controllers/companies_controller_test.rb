require "test_helper"

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @company = companies(:company_one)
    @user = users(:user_one)
    @other_org_user = users(:user_three)
    @organization = organizations(:organization_one)
    sign_in @user
  end

  test "should get index when authenticated" do
    get companies_url
    assert_response :success
  end

  test "should redirect index when not authenticated" do
    sign_out @user
    get companies_url
    assert_redirected_to new_user_session_path
  end

  test "should get new" do
    get new_company_url
    assert_response :success
  end

  test "should create company with valid data" do
    assert_difference("Company.count") do
      post companies_url, params: { 
        company: { 
          name: "New Company",
          phone_number: "1234567890",
          url_site: "https://example.com",
          linkedin_link: "https://linkedin.com/company/example",
          description: "Test company",
          employer_range: "10-50"
        }
      }
    end
    assert_redirected_to company_url(Company.last)
  end

  test "should not create company with invalid URLs" do
    assert_no_difference("Company.count") do
      company_params = {
        name: "New Company",
        url_site: "invalid-url",
        employers_min: 1,
        employers_max: 2,
        phone_number: "1234567890",
        organization: @organization
      }
      post companies_url, params: { company: { company: company_params } }
    end
    assert_response :unprocessable_entity
  end

  test "should show company for user in same organization" do
    get company_url(@company)
    assert_response :success
  end

  test "should not show company for user in different organization" do
    sign_in @other_org_user
    get company_url(@company)
    assert_redirected_to root_path
    assert_equal "Access Denied", flash[:alert]
  end

  test "should get edit" do
    get edit_company_url(@company)
    assert_response :success
  end

  test "should update company with valid data" do
    patch company_url(@company), params: { 
      company: {
        name: "Updated Company",
        url_site: "https://example.com",
        linkedin_link: "https://linkedin.com/company/example",
        employer_range: "100-200"
      }
    }
    assert_redirected_to company_url(@company)
    assert_equal "Company was successfully updated.", flash[:notice]
    @company.reload
    assert_equal "Updated Company", @company.name
    assert_equal 100, @company.employers_min
    assert_equal 200, @company.employers_max
  end

  test "should not update company with invalid URLs" do
    patch company_url(@company), params: { 
      company: {
        url_site: "invalid-url",
        linkedin_link: "invalid-url"
      }
    }
    assert_redirected_to edit_company_path(@company)
    assert_equal "Not a valid URL", flash[:alert]
  end

  test "should destroy company" do
    assert_difference("Company.count", -1) do
      delete company_url(@company)
    end
    assert_redirected_to companies_path
    assert_equal "Company was successfully deleted.", flash[:notice]
  end
end