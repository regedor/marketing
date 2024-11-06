require "application_system_test_case"

class PersoncompaniesTest < ApplicationSystemTestCase
  setup do
    @personcompany = personcompanies(:one)
  end

  test "visiting the index" do
    visit personcompanies_url
    assert_selector "h1", text: "Personcompanies"
  end

  test "should create personcompany" do
    visit personcompanies_url
    click_on "New personcompany"

    fill_in "Company", with: @personcompany.company_id
    check "Is working" if @personcompany.is_working
    fill_in "Person", with: @personcompany.person_id
    click_on "Create Personcompany"

    assert_text "Personcompany was successfully created"
    click_on "Back"
  end

  test "should update Personcompany" do
    visit personcompany_url(@personcompany)
    click_on "Edit this personcompany", match: :first

    fill_in "Company", with: @personcompany.company_id
    check "Is working" if @personcompany.is_working
    fill_in "Person", with: @personcompany.person_id
    click_on "Update Personcompany"

    assert_text "Personcompany was successfully updated"
    click_on "Back"
  end

  test "should destroy Personcompany" do
    visit personcompany_url(@personcompany)
    click_on "Destroy this personcompany", match: :first

    assert_text "Personcompany was successfully destroyed"
  end
end
