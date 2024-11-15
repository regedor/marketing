require "test_helper"

class PipelinesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @pipeline = pipelines(:pipeline_one)
    @pipeline_two = pipelines(:pipeline_two)
    @user = users(:user_one)
    @other_org_user = users(:user_three)
    @organization = organizations(:organization_one)
    sign_in @user
  end

  test "should get new" do
    get new_pipeline_url
    assert_response :success
  end

  test "should create pipeline" do
    assert_difference("Pipeline.count") do
      post pipelines_url, params: {
        pipeline: {
          name: "New Pipeline",
          to_people: true
        }
      }
    end
    assert_redirected_to pipeline_url(Pipeline.last)
    assert_equal "Pipeline was successfully created.", flash[:notice]
  end

  test "should not create pipeline with invalid data" do
    assert_no_difference("Pipeline.count") do
      post pipelines_url, params: { pipeline: { name: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "should show pipeline" do
    get pipeline_url(@pipeline)
    assert_response :success
    assert_not_nil assigns(:new_pipeattribute)
    assert_not_nil assigns(:new_stage)
    assert_not_nil assigns(:indexs)
  end

  test "should get edit" do
    get edit_pipeline_url(@pipeline)
    assert_response :success
  end

  test "should update pipeline" do
    patch pipeline_url(@pipeline), params: {
      pipeline: {
        name: "Updated Pipeline",
        to_people: false
      }
    }
    assert_redirected_to pipeline_url(@pipeline)
    assert_equal "Pipeline was successfully updated.", flash[:notice]
  end

  test "should not update pipeline with invalid data" do
    patch pipeline_url(@pipeline), params: { pipeline: { name: "" } }
    assert_response :unprocessable_entity
  end

  test "should destroy pipeline" do
    assert_difference("Pipeline.count", -1) do
      delete pipeline_url(@pipeline)
    end
    assert_redirected_to pipelines_url
    assert_equal "Pipeline was successfully destroyed.", flash[:notice]
  end

  test "should get selector" do
    get selector_pipelines_url
    assert_response :success
  end

  test "should select pipeline and redirect to new lead" do
    post select_pipeline_pipelines_url, params: {
      pipeline: { pipeline_id: @pipeline.id }
    }
    assert_redirected_to new_pipeline_lead_url(@pipeline)
  end

  test "should not select pipeline without pipeline_id" do
    post select_pipeline_pipelines_url, params: { pipeline: { pipeline_id: "" } }
    assert_redirected_to selector_pipelines_url
    assert_equal "Select a pipeline.", flash[:alert]
  end

  test "should deny access to other organization's pipeline" do
    sign_in @other_org_user
    get pipeline_url(@pipeline)
    assert_redirected_to root_path
    assert_equal "Access Denied", flash[:alert]
  end
end
