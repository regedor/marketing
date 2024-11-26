require "test_helper"

class LeadsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @pipeline = pipelines(:pipeline_one)
    @lead = leads(:lead_one)
    sign_in users(:user_two)
  end

  test "should show lead" do
    get pipeline_lead_url(@pipeline, @lead)
    assert_response :success
  end

  test "should get new" do
    get new_pipeline_lead_url(@pipeline)
    assert_response :success
  end

  test "should create lead" do
    assert_difference("Lead.count") do
      post pipeline_leads_url(@pipeline), params: { lead: { name: "NewLead", description: "NewDescription", start_date: "2024-10-29", end_date: "2024-11-29", company_id: companies(:company_one).id } }
    end
    assert_redirected_to pipeline_lead_path(@pipeline, Lead.last)
  end

  test "should not create lead with invalid data" do
    assert_no_difference("Lead.count") do
      post pipeline_leads_url(@pipeline), params: { lead: { name: "", description: "", start_date: "", end_date: "", company_id: companies(:company_one).id } }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_pipeline_lead_url(@pipeline, @lead)
    assert_response :success
  end

  test "should update lead" do
    LeadsController.any_instance.stubs(:check_company_people!).returns(true)
    patch pipeline_lead_url(@pipeline, @lead), params: { lead: { name: "UpdatedLead", description: "UpdatedDescription" } }
    assert_redirected_to pipeline_lead_path(@pipeline, @lead)
  end

  test "should not update lead with invalid data" do
    LeadsController.any_instance.stubs(:check_company_people!).returns(true)
    patch pipeline_lead_url(@pipeline, @lead), params: { lead: { start_date: "", end_date: "" } }
    assert_response :unprocessable_entity
  end

  test "should destroy lead" do
    assert_difference("Lead.count", -1) do
      delete pipeline_lead_url(@pipeline, @lead)
    end
    assert_redirected_to pipeline_path(@pipeline)
  end

  test "should update stage" do
    patch update_stage_pipeline_lead_url(@pipeline, @lead), params: { lead: { stage_id: stages(:stage_two).id } }
    assert_redirected_to pipeline_lead_path(@pipeline, @lead)
  end

  test "should not update stage with invalid data" do
    patch update_stage_pipeline_lead_url(@pipeline, @lead), params: { lead: { stage_id: nil } }
    assert_response :unprocessable_entity
  end
end
