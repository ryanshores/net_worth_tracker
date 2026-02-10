class BalanceSnapshot < ApplicationRecord
  belongs_to :account
  t.index [ :account_id, :date ], unique: true
end
