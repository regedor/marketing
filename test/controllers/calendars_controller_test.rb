require 'test_helper'

class CalendarsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
  
    setup do
        @calendar = calendars(:calendar_one)
        @user = users(:user_one)
        sign_in @user
    end

    test "should get index" do
        get calendars_url
        assert_response :success
        assert_not_nil assigns(:calendars)
    end

    test "should create calendar" do
        assert_difference('Calendar.count') do
        post calendars_url, params: { calendar: { name: 'New Calendar' } }
        end
        assert_redirected_to calendars_url
    end

    test "should not create calendar with invalid data" do
        assert_no_difference('Calendar.count') do
        post calendars_url, params: { calendar: { name: '' } }
        end
        assert_response :unprocessable_entity
    end

    test "should get edit" do
        get edit_calendar_url(@calendar)
        assert_response :success
    end

    test "should update calendar" do
        patch calendar_url(@calendar), params: { calendar: { name: 'Updated Calendar' } }
        assert_redirected_to calendars_url
    end

    test "should not update calendar with invalid data" do
        patch calendar_url(@calendar), params: { calendar: { name: '' } }
        assert_response :unprocessable_entity
    end

    test "should destroy calendar" do
        assert_difference('Calendar.count', -1) do
        delete calendar_url(@calendar)
        end
        assert_redirected_to calendars_url
    end

    test "should get selector" do
        get selector_calendars_url
        assert_response :success
    end

    test "should select calendar" do
        post select_calendar_calendars_url, params: { calendar: { calendar_id: @calendar.id } }
        assert_redirected_to new_calendar_post_path(@calendar)
    end
end