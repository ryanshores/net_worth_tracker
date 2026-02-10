class Account < ApplicationRecord
  belongs_to :institution
  t.string :plaid_account_id, null: false
  t.index :plaid_account_id, unique: true
end
