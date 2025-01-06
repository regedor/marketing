require "test_helper"

class PersonlinksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_one)
    @person = people(:person_one)
    @personlink = personlinks(:person_links_one)
    sign_in @user
  end

  test "should create personlink with valid url" do
    assert_difference("Personlink.count") do
      post person_personlinks_path(@person), params: {
        personlink: {
          name: "Test Link",
          link: "https://example.com"
        }
      }
    end
    assert_redirected_to person_path(@person)
    assert_equal "Entry was successfully updated.", flash[:notice]
  end

  test "should not create personlink with invalid url" do
    assert_no_difference("Personlink.count") do
      post person_personlinks_path(@person), params: {
        personlink: {
          name: "Invalid Link",
          link: "not-a-url"
        }
      }
    end
    assert_redirected_to person_path(@person)
    assert_equal "Not a valid URL", flash[:alert]
  end

  test "should not create duplicate personlink" do
    assert_no_difference("Personlink.count") do
      post person_personlinks_path(@person), params: {
        personlink: {
          name: @personlink.name,
          link: "https://example.com"
        }
      }
    end
    assert_redirected_to person_path(@person)
    assert_equal "Entry already exists for this person.", flash[:alert]
  end

  test "should destroy personlink" do
    assert_difference("Personlink.count", -1) do
      delete destroy_content_person_personlink_path(@person, @personlink, name: @personlink.name)
    end
    assert_redirected_to person_path(@person)
    assert_equal "Content removed successfully.", flash[:notice]
  end

  test "should not allow access from different organization" do
    @user.update(organization: organizations(:organization_two))

    post person_personlinks_path(@person), params: {
      personlink: {
        name: "Test Link",
        link: "https://example.com"
      }
    }

    assert_redirected_to root_path
    assert_equal "Access Denied", flash[:alert]
  end
end
