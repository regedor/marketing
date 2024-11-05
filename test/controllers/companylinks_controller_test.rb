require "test_helper"

class CompanylinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @companylink = companylinks(:one)
  end

  test "should get index" do
    get companylinks_url
    assert_response :success
  end

  test "should get new" do
    get new_companylink_url
    assert_response :success
  end

  test "should create companylink" do
    assert_difference("Companylink.count") do
      post companylinks_url, params: { companylink: { company_id: @companylink.company_id, link: @companylink.link, name: @companylink.name } }
    end

    assert_redirected_to companylink_url(Companylink.last)
  end

  test "should show companylink" do
    get companylink_url(@companylink)
    assert_response :success
  end

  test "should get edit" do
    get edit_companylink_url(@companylink)
    assert_response :success
  end

  test "should update companylink" do
    patch companylink_url(@companylink), params: { companylink: { company_id: @companylink.company_id, link: @companylink.link, name: @companylink.name } }
    assert_redirected_to companylink_url(@companylink)
  end

  test "should destroy companylink" do
    assert_difference("Companylink.count", -1) do
      delete companylink_url(@companylink)
    end

    assert_redirected_to companylinks_url
  end
end
