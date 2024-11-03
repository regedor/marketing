require "test_helper"

class LeadcontentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @leadcontent = leadcontents(:one)
  end

  test "should get index" do
    get leadcontents_url
    assert_response :success
  end

  test "should get new" do
    get new_leadcontent_url
    assert_response :success
  end

  test "should create leadcontent" do
    assert_difference("Leadcontent.count") do
      post leadcontents_url, params: { leadcontent: { lead_id: @leadcontent.lead_id, pipeattribute_id: @leadcontent.pipeattribute_id, value: @leadcontent.value } }
    end

    assert_redirected_to leadcontent_url(Leadcontent.last)
  end

  test "should show leadcontent" do
    get leadcontent_url(@leadcontent)
    assert_response :success
  end

  test "should get edit" do
    get edit_leadcontent_url(@leadcontent)
    assert_response :success
  end

  test "should update leadcontent" do
    patch leadcontent_url(@leadcontent), params: { leadcontent: { lead_id: @leadcontent.lead_id, pipeattribute_id: @leadcontent.pipeattribute_id, value: @leadcontent.value } }
    assert_redirected_to leadcontent_url(@leadcontent)
  end

  test "should destroy leadcontent" do
    assert_difference("Leadcontent.count", -1) do
      delete leadcontent_url(@leadcontent)
    end

    assert_redirected_to leadcontents_url
  end
end
