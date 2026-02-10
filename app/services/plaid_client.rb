# frozen_string_literal: true

class PlaidClient
  def self.client
    @client ||= begin
      configuration = Plaid::Configuration.new
      configuration.server_index = server_index_for(ENV.fetch("PLAID_ENV", "sandbox"))
      configuration.api_key["PLAID-CLIENT-ID"] = ENV.fetch("PLAID_CLIENT_ID")
      configuration.api_key["PLAID-SECRET"] = ENV.fetch("PLAID_SECRET")

      api_client = Plaid::ApiClient.new(configuration)
      Plaid::PlaidApi.new(api_client)
    end
  end

  private

  def self.server_index_for(env)
    normalized = env.to_s.downcase

    # Accept common inputs and keep behavior stable across machines
    normalized = "sandbox" if normalized == "development"

    case normalized
    when "sandbox" then Plaid::Configuration::Environment["sandbox"]
    when "production" then Plaid::Configuration::Environment["production"]
    when "development" then Plaid::Configuration::Environment["development"]
    else
      raise ArgumentError, "Unsupported PLAID_ENV=#{env.inspect}. Use sandbox, development, or production."
    end
  end
end
