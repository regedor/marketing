require "test_helper"

class LeadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lead = leads(:one)
  end

  test "should get index" do
    get leads_url
    assert_response :success
  end

  test "should get new" do
    get new_lead_url
    assert_response :success
  end

  test "should create lead" do
    assert_difference("Lead.count") do
      post leads_url, params: { lead: { company_id: @lead.company_id, content: @lead.content, end_date: @lead.end_date, name: @lead.name, pipeline_id: @lead.pipeline_id, start_date: @lead.start_date } }
    end

    assert_redirected_to lead_url(Lead.last)
  end

  test "should show lead" do
    get lead_url(@lead)
    assert_response :success
  end

  test "should get edit" do
    get edit_lead_url(@lead)
    assert_response :success
  end

  test "should update lead" do
    patch lead_url(@lead), params: { lead: { company_id: @lead.company_id, content: @lead.content, end_date: @lead.end_date, name: @lead.name, pipeline_id: @lead.pipeline_id, start_date: @lead.start_date } }
    assert_redirected_to lead_url(@lead)
  end

  test "should destroy lead" do
    assert_difference("Lead.count", -1) do
      delete lead_url(@lead)
    end

    assert_redirected_to leads_url
  end
end
