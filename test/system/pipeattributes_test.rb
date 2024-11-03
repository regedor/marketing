require "application_system_test_case"

class PipeattributesTest < ApplicationSystemTestCase
  setup do
    @pipeattribute = pipeattributes(:one)
  end

  test "visiting the index" do
    visit pipeattributes_url
    assert_selector "h1", text: "Pipeattributes"
  end

  test "should create pipeattribute" do
    visit pipeattributes_url
    click_on "New pipeattribute"

    fill_in "Name", with: @pipeattribute.name
    fill_in "Pipeline", with: @pipeattribute.pipeline_id
    click_on "Create Pipeattribute"

    assert_text "Pipeattribute was successfully created"
    click_on "Back"
  end

  test "should update Pipeattribute" do
    visit pipeattribute_url(@pipeattribute)
    click_on "Edit this pipeattribute", match: :first

    fill_in "Name", with: @pipeattribute.name
    fill_in "Pipeline", with: @pipeattribute.pipeline_id
    click_on "Update Pipeattribute"

    assert_text "Pipeattribute was successfully updated"
    click_on "Back"
  end

  test "should destroy Pipeattribute" do
    visit pipeattribute_url(@pipeattribute)
    click_on "Destroy this pipeattribute", match: :first

    assert_text "Pipeattribute was successfully destroyed"
  end
end
