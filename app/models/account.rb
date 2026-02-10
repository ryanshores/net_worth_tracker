class Account < ApplicationRecord
  belongs_to :institution
  has_many :balance_snapshots, dependent: :destroy
end
