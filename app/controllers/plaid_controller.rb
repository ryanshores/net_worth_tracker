class PlaidController < ApplicationController
  protect_from_forgery with: :null_session

  def link_token
    response = PlaidClient.client.link_token_create(
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
    params.permit(:institution_id, :institution_name, :public_token)
    params.require([ :institution_name, :public_token ])

    exchange = PlaidClient.client.item_public_token_exchange(
      public_token: params[:public_token]
    )

    institution = if params[:institution_id].present?
      Institution.find(params[:institution_id])
    else
      Institution.create!(name: params[:institution_name])
    end

    institution.update!(
      access_token: exchange.access_token,
      status: :ok
    )

    head :ok
  end

  def refresh_token
    params.require([ :institution_id ])

    institution = Institution.find(params[:institution_id])

    response = PlaidClient.client.link_token_create(
      user: {
        client_user_id: "single_user"
      },
      client_name: "Net Worth Tracker",
      access_token: institution.access_token,
      country_codes: [ "US" ],
      language: "en"
    )

    render json: { link_token: response.link_token }
  end
end
