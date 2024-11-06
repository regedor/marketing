require "application_system_test_case"

class PersonlinksTest < ApplicationSystemTestCase
  setup do
    @personlink = personlinks(:one)
  end

  test "visiting the index" do
    visit personlinks_url
    assert_selector "h1", text: "Personlinks"
  end

  test "should create personlink" do
    visit personlinks_url
    click_on "New personlink"

    fill_in "Content", with: @personlink.content
    fill_in "Person", with: @personlink.person_id
    click_on "Create Personlink"

    assert_text "Personlink was successfully created"
    click_on "Back"
  end

  test "should update Personlink" do
    visit personlink_url(@personlink)
    click_on "Edit this personlink", match: :first

    fill_in "Content", with: @personlink.content
    fill_in "Person", with: @personlink.person_id
    click_on "Update Personlink"

    assert_text "Personlink was successfully updated"
    click_on "Back"
  end

  test "should destroy Personlink" do
    visit personlink_url(@personlink)
    click_on "Destroy this personlink", match: :first

    assert_text "Personlink was successfully destroyed"
  end
end
