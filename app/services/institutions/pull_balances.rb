# frozen_string_literal: true

module Institutions
  class PullBalances
    def self.call(institution, **kwargs)
      new(institution, **kwargs).call
    end

    def initialize(institution, now: Time.current, logger: Rails.logger)
      @institution = institution
      @now = now
      @logger = logger
    end

    def call
      validate! # check for required params
      logger.info "[PullBalances] institution:#{institution.name} msg:start"
      accounts = fetch_accounts # fetch accounts from Plaid
      persist!(accounts) # persist accounts and balances
      accounts # return account
    rescue StandardError => e
      logger.error "[PullBalances] institution:#{institution.name} error:#{e.class} msg:#{e.message}"
      raise
    ensure
      logger.info "[PullBalances] institution:#{institution.name} msg:end"
    end

    private

    attr_reader :institution, :now, :logger

    def validate!
      raise ArgumentError, "institution must be present" if institution.nil?
      raise ArgumentError, "institution must be persisted" unless institution.persisted?
      raise ArgumentError, "institution must not need auth" unless institution.ok?
    end

    def fetch_accounts
      resp = PlaidClient.client.accounts_balance_get(access_token: institution.access_token)
      resp.accounts
    rescue Plaid::ApiError => e
      handle_plaid_error(e)
    end

    def handle_plaid_error(e)
      if e.respond_to?(:error_code) && e.error_code == "ITEM_LOGIN_REQUIRED"
        institution.update!(needs_auth: true)
      else
        logger.error "[PullBalances] institution:#{institution.name} error:#{e.class} msg:#{e.message}"
      end
    end

    def persist!(accounts)
      accounts.each do |acct|
        # Find or create an account with Plaid account ID
        account = Account.find_or_initialize_by(plaid_account_id: acct.account_id)

        # Update account attributes from Plaid account data
        account.update!(
          account_type: acct.type,
          institution: institution,
          name: acct.name,
          subtype: acct.subtype
        )

        BalanceSnapshot.upsert(
          {
            account_id: account.id,
            available: acct.balances.available,
            currency: acct.balances.iso_currency_code,
            current: acct.balances.current,
            date: now
          },
          unique_by: %i[account_id date]
        )
      end
    end
  end
end
