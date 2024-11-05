require "application_system_test_case"

class LeadcontentsTest < ApplicationSystemTestCase
  setup do
    @leadcontent = leadcontents(:one)
  end

  test "visiting the index" do
    visit leadcontents_url
    assert_selector "h1", text: "Leadcontents"
  end

  test "should create leadcontent" do
    visit leadcontents_url
    click_on "New leadcontent"

    fill_in "Lead", with: @leadcontent.lead_id
    fill_in "Pipeattribute", with: @leadcontent.pipeattribute_id
    fill_in "Value", with: @leadcontent.value
    click_on "Create Leadcontent"

    assert_text "Leadcontent was successfully created"
    click_on "Back"
  end

  test "should update Leadcontent" do
    visit leadcontent_url(@leadcontent)
    click_on "Edit this leadcontent", match: :first

    fill_in "Lead", with: @leadcontent.lead_id
    fill_in "Pipeattribute", with: @leadcontent.pipeattribute_id
    fill_in "Value", with: @leadcontent.value
    click_on "Update Leadcontent"

    assert_text "Leadcontent was successfully updated"
    click_on "Back"
  end

  test "should destroy Leadcontent" do
    visit leadcontent_url(@leadcontent)
    click_on "Destroy this leadcontent", match: :first

    assert_text "Leadcontent was successfully destroyed"
  end
end
