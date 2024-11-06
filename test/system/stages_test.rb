require "application_system_test_case"

class StagesTest < ApplicationSystemTestCase
  setup do
    @stage = stages(:one)
  end

  test "visiting the index" do
    visit stages_url
    assert_selector "h1", text: "Stages"
  end

  test "should create stage" do
    visit stages_url
    click_on "New stage"

    check "Is final" if @stage.is_final
    fill_in "Name", with: @stage.name
    fill_in "Pipeline", with: @stage.pipeline_id
    click_on "Create Stage"

    assert_text "Stage was successfully created"
    click_on "Back"
  end

  test "should update Stage" do
    visit stage_url(@stage)
    click_on "Edit this stage", match: :first

    check "Is final" if @stage.is_final
    fill_in "Name", with: @stage.name
    fill_in "Pipeline", with: @stage.pipeline_id
    click_on "Update Stage"

    assert_text "Stage was successfully updated"
    click_on "Back"
  end

  test "should destroy Stage" do
    visit stage_url(@stage)
    click_on "Destroy this stage", match: :first

    assert_text "Stage was successfully destroyed"
  end
end
