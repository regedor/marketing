require "test_helper"

class LeadcontentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @pipeline = pipelines(:pipeline_one)
    @lead = leads(:lead_one)
    @leadcontent = leadcontents(:lead_content_one)
    sign_in users(:user_one)
  end

  test "should get edit" do
    get edit_pipeline_lead_leadcontent_url(@pipeline, @lead, @leadcontent)
    assert_response :success
  end

  test "should update leadcontent" do
    patch pipeline_lead_leadcontent_url(@pipeline, @lead, @leadcontent), params: { leadcontent: { value: "UpdatedValue" } }
    assert_redirected_to pipeline_lead_path(@pipeline, @lead)
  end
end
