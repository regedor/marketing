require "application_system_test_case"

class LeadsTest < ApplicationSystemTestCase
  setup do
    @lead = leads(:one)
  end

  test "visiting the index" do
    visit leads_url
    assert_selector "h1", text: "Leads"
  end

  test "should create lead" do
    visit leads_url
    click_on "New lead"

    fill_in "Company", with: @lead.company_id
    fill_in "Content", with: @lead.content
    fill_in "End date", with: @lead.end_date
    fill_in "Name", with: @lead.name
    fill_in "Pipeline", with: @lead.pipeline_id
    fill_in "Start date", with: @lead.start_date
    click_on "Create Lead"

    assert_text "Lead was successfully created"
    click_on "Back"
  end

  test "should update Lead" do
    visit lead_url(@lead)
    click_on "Edit this lead", match: :first

    fill_in "Company", with: @lead.company_id
    fill_in "Content", with: @lead.content
    fill_in "End date", with: @lead.end_date
    fill_in "Name", with: @lead.name
    fill_in "Pipeline", with: @lead.pipeline_id
    fill_in "Start date", with: @lead.start_date
    click_on "Update Lead"

    assert_text "Lead was successfully updated"
    click_on "Back"
  end

  test "should destroy Lead" do
    visit lead_url(@lead)
    click_on "Destroy this lead", match: :first

    assert_text "Lead was successfully destroyed"
  end
end
