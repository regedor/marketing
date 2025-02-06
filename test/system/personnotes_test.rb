require "application_system_test_case"

class PersonnotesTest < ApplicationSystemTestCase
  setup do
    @personnote = personnotes(:one)
  end

  test "visiting the index" do
    visit personnotes_url
    assert_selector "h1", text: "Personnotes"
  end

  test "should create personnote" do
    visit personnotes_url
    click_on "New personnote"

    fill_in "Note", with: @personnote.note
    fill_in "Person", with: @personnote.person_id
    fill_in "User", with: @personnote.member_id
    click_on "Create Personnote"

    assert_text "Personnote was successfully created"
    click_on "Back"
  end

  test "should update Personnote" do
    visit personnote_url(@personnote)
    click_on "Edit this personnote", match: :first

    fill_in "Note", with: @personnote.note
    fill_in "Person", with: @personnote.person_id
    fill_in "User", with: @personnote.member_id
    click_on "Update Personnote"

    assert_text "Personnote was successfully updated"
    click_on "Back"
  end

  test "should destroy Personnote" do
    visit personnote_url(@personnote)
    click_on "Destroy this personnote", match: :first

    assert_text "Personnote was successfully destroyed"
  end
end
