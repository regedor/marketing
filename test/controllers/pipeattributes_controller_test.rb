require "test_helper"

class PipeattributesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @pipeline = pipelines(:pipeline_one)
    @pipeattribute = pipeattributes(:pipe_one_attribute_one)
    @user = users(:user_one)
    sign_in @user
  end

  test "should create pipeattribute" do
    assert_difference('Pipeattribute.count') do
      post pipeline_pipeattributes_path(@pipeline), params: {
        pipeattribute: { name: "New Attribute" }
      }
    end
    assert_redirected_to pipeline_path(@pipeline)
    assert_equal "Pipeattribute was successfully created.", flash[:notice]
  end

  test "should not create pipeattribute with invalid data" do
    assert_no_difference('Pipeattribute.count') do
      post pipeline_pipeattributes_path(@pipeline), params: {
        pipeattribute: { name: "" }
      }
    end
    assert_match /Failed to create Pipeattribute/, flash[:alert]
  end

  test "should get edit" do
    get edit_pipeline_pipeattribute_path(@pipeline, @pipeattribute)
    assert_response :success
  end

  test "should update pipeattribute" do
    patch pipeline_pipeattribute_path(@pipeline, @pipeattribute), params: {
      pipeattribute: { name: "Updated Name" }
    }
    assert_redirected_to pipeline_path(@pipeline)
    assert_equal "Pipeattribute was successfully updated.", flash[:notice]
  end

  test "should not update pipeattribute with invalid data" do
    patch pipeline_pipeattribute_path(@pipeline, @pipeattribute), params: {
      pipeattribute: { name: "" }
    }
    assert_response :unprocessable_entity
  end

  test "should destroy pipeattribute" do
    assert_difference('Pipeattribute.count', -1) do
      delete pipeline_pipeattribute_path(@pipeline, @pipeattribute)
    end
    assert_redirected_to pipeline_path(@pipeline)
    assert_equal "Pipeattribute was successfully destroyed.", flash[:notice]
  end

  test "should deny access when not authenticated" do
    sign_out @user
    post pipeline_pipeattributes_path(@pipeline), params: {
      pipeattribute: { name: "New Attribute" }
    }
    assert_redirected_to new_user_session_path
  end

  test "should deny access from different organization" do
    @user.update(organization: organizations(:organization_two))
    post pipeline_pipeattributes_path(@pipeline), params: {
      pipeattribute: { name: "New Attribute" }
    }
    assert_redirected_to root_path
    assert_equal "Access Denied", flash[:alert]
  end
end