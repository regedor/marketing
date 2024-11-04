require 'test_helper'

class AttachmentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @calendar = calendars(:calendar_one)
    @post = posts(:post_one)
    @perspective = perspectives(:perspective_one)
    @attachment = attachments(:attachment_one)
    @user = users(:user_one)
    sign_in @user
  end

  test "should create attachment" do
    assert_difference('Attachment.count') do
      attachment_params = {
        filename: 'test.txt',
        content: fixture_file_upload('test-file.txt', 'text/plain'),
        original_filename: 'test.txt',
      }
      post calendar_post_perspective_attachments_url(@calendar, @post, @perspective), params: { attachment: attachment_params }
    end
    assert_redirected_to calendar_post_perspective_path(@calendar, @post, @perspective)
  end

  # test "should get edit" do
  #   get edit_calendar_post_perspective_attachment_url(@calendar, @post, @perspective, @attachment)
  #   assert_response :success
  # end

  # test "should update attachment" do
  #   patch calendar_post_perspective_attachment_url(@calendar, @post, @perspective, @attachment), params: { attachment: { filename: 'updated.txt' } }
  #   assert_redirected_to calendar_post_perspective_path(@calendar, @post, @perspective)
  # end

  # test "should not update attachment with invalid data" do
  #   patch calendar_post_perspective_attachment_url(@calendar, @post, @perspective, @attachment), params: { attachment: { filename: '' } }
  #   assert_response :unprocessable_entity
  # end

  test "should destroy attachment" do
    assert_difference('Attachment.count', -1) do
      delete calendar_post_perspective_attachment_url(@calendar, @post, @perspective, @attachment)
    end
  end  

  test "should download attachment" do
    get download_calendar_post_perspective_attachment_url(@calendar, @post, @perspective, @attachment)
    assert_response :success
  end

  test "should approve attachment" do
    patch update_status_calendar_post_perspective_attachment_url(@calendar, @post, @perspective, @attachment), params: { attachment: { status: "approved" } }
    @attachment.reload
    assert_equal "approved", @attachment.status
    assert_redirected_to calendar_post_perspective_path(@calendar, @post, @perspective)
  end  

  test "should set attachment in analysis" do
    patch update_status_calendar_post_perspective_attachment_url(@calendar, @post, @perspective, @attachment), params: { attachment: { status: "in_analysis" } }
    @attachment.reload
    assert_equal "in_analysis", @attachment.status
    assert_redirected_to calendar_post_perspective_path(@calendar, @post, @perspective)
  end  

  test "should reject attachment" do
    patch update_status_calendar_post_perspective_attachment_url(@calendar, @post, @perspective, @attachment), params: { attachment: { status: "rejected" } }
    @attachment.reload
    assert_equal "rejected", @attachment.status
    assert_redirected_to calendar_post_perspective_path(@calendar, @post, @perspective)
  end  
end
