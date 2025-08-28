require "test_helper"

class InquiryControllerTest < ActionDispatch::IntegrationTest
  test "should get inquiry" do
    get inquiry_inquiry_url
    assert_response :success
  end
end
