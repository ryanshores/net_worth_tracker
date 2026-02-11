require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "index renders successfully and lists institutions" do
    Institution.create!(name: "Bank A", access_token: "token-a", status: :ok)
    Institution.create!(name: "Bank B", access_token: "token-b", status: :needs_auth)

    get "/"
    assert_response :success

    assert_includes response.body, "Bank A"
    assert_includes response.body, "Bank B"
    assert_includes response.body, "needs reauth"
  end
end
