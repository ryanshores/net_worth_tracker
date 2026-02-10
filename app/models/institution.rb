class Institution < ApplicationRecord
  encrypts :access_token
  has_many :accounts, dependent: :destroy
  enum status: { ok: 0, needs_auth: 1 }
end
