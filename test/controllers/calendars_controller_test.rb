require "test_helper"

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
    end

    test "should create calendar" do
        assert_difference("Calendar.count") do
        post calendars_url, params: { calendar: { name: "New Calendar" } }
        end
        assert_redirected_to dashboard_url
    end

    test "should get edit" do
        get edit_calendar_url(@calendar)
        assert_response :success
    end

    test "should update calendar" do
        patch calendar_url(@calendar), params: { calendar: { name: "Updated Calendar" } }
        assert_redirected_to dashboard_url
    end

    test "should not update calendar with invalid data" do
        patch calendar_url(@calendar), params: { calendar: { name: "" } }
        assert_response :unprocessable_entity
    end

    test "should destroy calendar" do
        assert_difference("Calendar.count", -1) do
            delete calendar_url(@calendar.id)
        end
    end
end
