require "test_helper"

class CheckControllerTest < ActionDispatch::IntegrationTest
  test "should get inquiry" do
    get check_inquiry_url
    assert_response :success
  end
end
