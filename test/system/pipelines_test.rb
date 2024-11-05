require "application_system_test_case"

class PipelinesTest < ApplicationSystemTestCase
  setup do
    @pipeline = pipelines(:one)
  end

  test "visiting the index" do
    visit pipelines_url
    assert_selector "h1", text: "Pipelines"
  end

  test "should create pipeline" do
    visit pipelines_url
    click_on "New pipeline"

    fill_in "Name", with: @pipeline.name
    fill_in "Organization", with: @pipeline.organization_id
    click_on "Create Pipeline"

    assert_text "Pipeline was successfully created"
    click_on "Back"
  end

  test "should update Pipeline" do
    visit pipeline_url(@pipeline)
    click_on "Edit this pipeline", match: :first

    fill_in "Name", with: @pipeline.name
    fill_in "Organization", with: @pipeline.organization_id
    click_on "Update Pipeline"

    assert_text "Pipeline was successfully updated"
    click_on "Back"
  end

  test "should destroy Pipeline" do
    visit pipeline_url(@pipeline)
    click_on "Destroy this pipeline", match: :first

    assert_text "Pipeline was successfully destroyed"
  end
end
