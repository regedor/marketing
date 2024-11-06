require "test_helper"

class PipeattributesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pipeattribute = pipeattributes(:one)
  end

  test "should get index" do
    get pipeattributes_url
    assert_response :success
  end

  test "should get new" do
    get new_pipeattribute_url
    assert_response :success
  end

  test "should create pipeattribute" do
    assert_difference("Pipeattribute.count") do
      post pipeattributes_url, params: { pipeattribute: { name: @pipeattribute.name, pipeline_id: @pipeattribute.pipeline_id } }
    end

    assert_redirected_to pipeattribute_url(Pipeattribute.last)
  end

  test "should show pipeattribute" do
    get pipeattribute_url(@pipeattribute)
    assert_response :success
  end

  test "should get edit" do
    get edit_pipeattribute_url(@pipeattribute)
    assert_response :success
  end

  test "should update pipeattribute" do
    patch pipeattribute_url(@pipeattribute), params: { pipeattribute: { name: @pipeattribute.name, pipeline_id: @pipeattribute.pipeline_id } }
    assert_redirected_to pipeattribute_url(@pipeattribute)
  end

  test "should destroy pipeattribute" do
    assert_difference("Pipeattribute.count", -1) do
      delete pipeattribute_url(@pipeattribute)
    end

    assert_redirected_to pipeattributes_url
  end
end
