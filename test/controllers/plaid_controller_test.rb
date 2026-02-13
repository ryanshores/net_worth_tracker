require "test_helper"

class PlaidControllerTest < ActionDispatch::IntegrationTest
  fake_client = Object.new
  def fake_client.link_token_create(access_token: nil, **)
    if access_token.present?
      OpenStruct.new(link_token: "updated_link_token")
    else
      OpenStruct.new(link_token: "link_token")
    end
  end
  def fake_client.item_public_token_exchange(**)
    OpenStruct.new(access_token: "access_token")
  end

  test "link_token returns a link token as json" do
    PlaidClient.stubs(:client).returns(fake_client)
    post "/plaid/link_token", as: :json
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal "link_token", json["link_token"]
  end

  test "exchange_token returns a new access token" do
    PlaidClient.stubs(:client).returns(fake_client)
    params = { institution_name: "Bank A", public_token: "public_token" }
    assert_difference "Institution.count", +1 do
      post "/plaid/exchange_token", params: params, as: :json
    end

    assert_response :success

    institution = Institution.last
    assert_equal params[:institution_name], institution.name
    assert_equal "access_token", institution.access_token
  end

  test "refresh_token refreshes an institution's access token" do
    PlaidClient.stubs(:client).returns(fake_client)
    institution = Institution.create!(name: "Bank A", access_token: "access_token")
    post "/plaid/refresh_token", params: { institution_id: institution.id }, as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "updated_link_token", json["link_token"]
  end
end
