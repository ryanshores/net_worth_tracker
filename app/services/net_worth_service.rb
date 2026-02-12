# frozen_string_literal: true

class NetWorthService
  ASSET_TYPES = %w[investment depository brokerage]
  LIABILITY_TYPES = %w[credit loan other]

  def self.time_series
    assets_balance = BalanceSnapshot
      .joins(:account)
      .where(accounts: {
        account_type: ASSET_TYPES
      })
      .group(:date)
      .sum(:current)
    liabilities_balance = BalanceSnapshot
      .joins(:account)
      .where(accounts: {
      account_type: LIABILITY_TYPES
      })
      .group(:date)
      .sum(:current)

    assets_balance.merge(liabilities_balance)
  end
end
