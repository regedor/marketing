require "test_helper"

class StagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_one)
    @other_user = users(:user_three)
    @pipeline = pipelines(:pipeline_one)
    @stage = stages(:stage_one)
    sign_in @user
  end

  test "should create stage" do
    assert_difference("Stage.count") do
      post pipeline_stages_url(@pipeline), params: { stage: { name: "New Stage" } }
    end
    assert_redirected_to edit_pipeline_url(@pipeline)
    assert_equal "Stage was successfully created.", flash[:notice]
  end

  test "should not create stage with invalid data" do
    assert_no_difference("Stage.count") do
      post pipeline_stages_url(@pipeline), params: { stage: { name: "" } }
    end
    assert_redirected_to pipeline_url(@pipeline)
    assert_match /Failed to create Stage/, flash[:alert]
  end

  test "should get edit" do
    get edit_pipeline_stage_url(@pipeline, @stage)
    assert_response :success
  end

  test "should update stage" do
    patch pipeline_stage_url(@pipeline, @stage), params: { stage: { name: "Updated Stage" } }
    assert_redirected_to edit_pipeline_path(@pipeline)
    assert_equal "Stage was successfully updated.", flash[:notice]
  end

  test "should not update stage with invalid data" do
    patch pipeline_stage_url(@pipeline, @stage), params: { stage: { name: "" } }
    assert_response :unprocessable_entity
  end

  test "should update index stage" do
    patch pipeline_stage_update_index_stage_path(@pipeline, @stage), params: { stage: { index: "2" } }
    assert_redirected_to edit_pipeline_path(@pipeline)
    @stage.reload
    assert_equal 2, @stage.index
  end

  test "should destroy stage" do
    assert_difference("Stage.count", -1) do
      delete pipeline_stage_url(@pipeline, @stage)
    end
    assert_redirected_to pipeline_url(@pipeline)
    assert_equal "Stage was successfully destroyed.", flash[:notice]
  end

  test "should not allow unauthorized access" do
    sign_out @user
    get edit_pipeline_stage_url(@pipeline, @stage)
    assert_redirected_to new_user_session_url
  end
end
