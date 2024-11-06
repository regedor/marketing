require "application_system_test_case"

class CompanylinksTest < ApplicationSystemTestCase
  setup do
    @companylink = companylinks(:one)
  end

  test "visiting the index" do
    visit companylinks_url
    assert_selector "h1", text: "Companylinks"
  end

  test "should create companylink" do
    visit companylinks_url
    click_on "New companylink"

    fill_in "Company", with: @companylink.company_id
    fill_in "Link", with: @companylink.link
    fill_in "Name", with: @companylink.name
    click_on "Create Companylink"

    assert_text "Companylink was successfully created"
    click_on "Back"
  end

  test "should update Companylink" do
    visit companylink_url(@companylink)
    click_on "Edit this companylink", match: :first

    fill_in "Company", with: @companylink.company_id
    fill_in "Link", with: @companylink.link
    fill_in "Name", with: @companylink.name
    click_on "Update Companylink"

    assert_text "Companylink was successfully updated"
    click_on "Back"
  end

  test "should destroy Companylink" do
    visit companylink_url(@companylink)
    click_on "Destroy this companylink", match: :first

    assert_text "Companylink was successfully destroyed"
  end
end
