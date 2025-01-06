require "test_helper"

class CompanylinksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_two)
    @company = companies(:company_one)
    @companylink = companylinks(:company_one_link_one)
    sign_in @user
  end

  test "should create companylink with valid url" do
    assert_difference("Companylink.count") do
      post company_companylinks_path(@company), params: {
        companylink: {
          name: "Test Link",
          link: "https://example.com"
        }
      }
    end
    assert_redirected_to company_path(@company)
    assert_equal "Entry was successfully created.", flash[:notice]
  end

  test "should not create companylink with invalid url" do
    assert_no_difference("Companylink.count") do
      post company_companylinks_path(@company), params: {
        companylink: {
          name: "Invalid Link",
          link: "not-a-url"
        }
      }
    end
    assert_redirected_to company_path(@company)
    assert_equal "Not a valid URL", flash[:alert]
  end

  test "should not create duplicate companylink" do
    assert_no_difference("Companylink.count") do
      post company_companylinks_path(@company), params: {
        companylink: {
          name: @companylink.name,
          link: @companylink.link
        }
      }
    end
    assert_redirected_to company_path(@company)
    assert_equal "Entry already exists for this company.", flash[:alert]
  end

  test "should not allow access from different organization" do
    @user.update(organization: organizations(:organization_two))

    post company_companylinks_path(@company), params: {
      companylink: {
        name: "Test Link",
        link: "https://example.com"
      }
    }

    assert_redirected_to root_path
    assert_equal "Access Denied", flash[:alert]
  end
end
