require "application_system_test_case"

class LeadnotesTest < ApplicationSystemTestCase
  setup do
    @leadnote = leadnotes(:one)
  end

  test "visiting the index" do
    visit leadnotes_url
    assert_selector "h1", text: "Leadnotes"
  end

  test "should create leadnote" do
    visit leadnotes_url
    click_on "New leadnote"

    fill_in "Lead", with: @leadnote.lead_id
    fill_in "Note", with: @leadnote.note
    fill_in "User", with: @leadnote.user_id
    click_on "Create Leadnote"

    assert_text "Leadnote was successfully created"
    click_on "Back"
  end

  test "should update Leadnote" do
    visit leadnote_url(@leadnote)
    click_on "Edit this leadnote", match: :first

    fill_in "Lead", with: @leadnote.lead_id
    fill_in "Note", with: @leadnote.note
    fill_in "User", with: @leadnote.user_id
    click_on "Update Leadnote"

    assert_text "Leadnote was successfully updated"
    click_on "Back"
  end

  test "should destroy Leadnote" do
    visit leadnote_url(@leadnote)
    click_on "Destroy this leadnote", match: :first

    assert_text "Leadnote was successfully destroyed"
  end
end
