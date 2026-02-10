# frozen_string_literal: true

class PlaidClient
  def self.client
    @client ||= Plaid.client.new(
      env: ENV.fetch("PLAID_ENV", "development").to_sym,
      client_id: ENV.fetch("PLAID_CLIENT_ID"),
      secret: ENV.fetch("PLAID_SECRET")
    )
  end
end
