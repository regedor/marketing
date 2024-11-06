require "application_system_test_case"

class PhonenumbersTest < ApplicationSystemTestCase
  setup do
    @phonenumber = phonenumbers(:one)
  end

  test "visiting the index" do
    visit phonenumbers_url
    assert_selector "h1", text: "Phonenumbers"
  end

  test "should create phonenumber" do
    visit phonenumbers_url
    click_on "New phonenumber"

    check "Current" if @phonenumber.current
    check "Is active" if @phonenumber.is_active
    fill_in "Number", with: @phonenumber.number
    fill_in "Person", with: @phonenumber.person_id
    click_on "Create Phonenumber"

    assert_text "Phonenumber was successfully created"
    click_on "Back"
  end

  test "should update Phonenumber" do
    visit phonenumber_url(@phonenumber)
    click_on "Edit this phonenumber", match: :first

    check "Current" if @phonenumber.current
    check "Is active" if @phonenumber.is_active
    fill_in "Number", with: @phonenumber.number
    fill_in "Person", with: @phonenumber.person_id
    click_on "Update Phonenumber"

    assert_text "Phonenumber was successfully updated"
    click_on "Back"
  end

  test "should destroy Phonenumber" do
    visit phonenumber_url(@phonenumber)
    click_on "Destroy this phonenumber", match: :first

    assert_text "Phonenumber was successfully destroyed"
  end
end
