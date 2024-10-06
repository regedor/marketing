require "test_helper"

class CrmControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get crm_index_url
    assert_response :success
  end
end
