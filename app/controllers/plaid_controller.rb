class PlaidController < ApplicationController
  protect_from_forgery with: :null_session

  def link_token
    client = PlaidClient.client
    response = client.link_token_create(
      user: {
        client_user_id: "single_user" # this would change if the app supported multiple users
      },
      client_name: "Net Worth Tracker",
      products: %w[auth transactions],
      language: "en",
      country_codes: [ "US" ]
    )

    render json: { link_token: response.link_token }
  end

  def exchange_token
    params.require([ :institution_name, :public_token ])

    exchange = PlaidClient.client.item_public_token_exchange(
      public_token: params[:public_token]
    )

    Institution.create!(
      name: params[:institution_name],
      access_token: exchange.access_token,
      status: :ok
    )

    head :ok
  end
end
