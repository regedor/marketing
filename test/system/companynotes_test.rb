require "application_system_test_case"

class CompanynotesTest < ApplicationSystemTestCase
  setup do
    @companynote = companynotes(:one)
  end

  test "visiting the index" do
    visit companynotes_url
    assert_selector "h1", text: "Companynotes"
  end

  test "should create companynote" do
    visit companynotes_url
    click_on "New companynote"

    fill_in "Company", with: @companynote.company_id
    fill_in "Note", with: @companynote.note
    fill_in "User", with: @companynote.user_id
    click_on "Create Companynote"

    assert_text "Companynote was successfully created"
    click_on "Back"
  end

  test "should update Companynote" do
    visit companynote_url(@companynote)
    click_on "Edit this companynote", match: :first

    fill_in "Company", with: @companynote.company_id
    fill_in "Note", with: @companynote.note
    fill_in "User", with: @companynote.user_id
    click_on "Update Companynote"

    assert_text "Companynote was successfully updated"
    click_on "Back"
  end

  test "should destroy Companynote" do
    visit companynote_url(@companynote)
    click_on "Destroy this companynote", match: :first

    assert_text "Companynote was successfully destroyed"
  end
end
