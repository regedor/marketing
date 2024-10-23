require "application_system_test_case"

class PublishplatformsTest < ApplicationSystemTestCase
  setup do
    @publishplatform = publishplatforms(:one)
  end

  test "visiting the index" do
    visit publishplatforms_url
    assert_selector "h1", text: "Publishplatforms"
  end

  test "should create publishplatform" do
    visit publishplatforms_url
    click_on "New publishplatform"

    fill_in "Post", with: @publishplatform.post_id
    fill_in "Social platform", with: @publishplatform.social_platform
    click_on "Create Publishplatform"

    assert_text "Publishplatform was successfully created"
    click_on "Back"
  end

  test "should update Publishplatform" do
    visit publishplatform_url(@publishplatform)
    click_on "Edit this publishplatform", match: :first

    fill_in "Post", with: @publishplatform.post_id
    fill_in "Social platform", with: @publishplatform.social_platform
    click_on "Update Publishplatform"

    assert_text "Publishplatform was successfully updated"
    click_on "Back"
  end

  test "should destroy Publishplatform" do
    visit publishplatform_url(@publishplatform)
    click_on "Destroy this publishplatform", match: :first

    assert_text "Publishplatform was successfully destroyed"
  end
end
