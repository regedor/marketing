require "test_helper"

class LeadnotesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @pipeline = pipelines(:pipeline_one)
    @lead = leads(:lead_one)
    @leadnote = leadnotes(:lead_note_one)
    sign_in users(:user_one)
  end

  test "should create leadnote" do
    assert_difference('Leadnote.count') do
      post pipeline_lead_leadnotes_url(@pipeline, @lead), params: { leadnote: { note: 'NewNote' } }
    end
    assert_redirected_to pipeline_lead_path(@pipeline, @lead)
  end

  test "should not create leadnote with invalid data" do
    assert_no_difference('Leadnote.count') do
      post pipeline_lead_leadnotes_url(@pipeline, @lead), params: { leadnote: { note: '' } }
    end
    assert_redirected_to pipeline_lead_path(@pipeline, @lead)
  end

  test "should get edit" do
    get edit_pipeline_lead_leadnote_url(@pipeline, @lead, @leadnote)
    assert_response :success
  end

  test "should update leadnote" do
    patch pipeline_lead_leadnote_url(@pipeline, @lead, @leadnote), params: { leadnote: { note: 'UpdatedNote' } }
    assert_redirected_to pipeline_lead_path(@pipeline, @lead)
  end

  test "should not update leadnote with invalid data" do
    patch pipeline_lead_leadnote_url(@pipeline, @lead, @leadnote), params: { leadnote: { note: '' } }
    assert_response :unprocessable_entity
  end

  test "should destroy leadnote" do
    assert_difference('Leadnote.count', -1) do
      delete pipeline_lead_leadnote_url(@pipeline, @lead, @leadnote)
    end
    assert_redirected_to pipeline_lead_path(@pipeline, @lead)
  end
end