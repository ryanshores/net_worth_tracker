class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts do |t|
      t.references :institution, null: false, foreign_key: true
      t.string :plaid_account_id, null: false
      t.index :plaid_account_id, unique: true
      t.string :name
      t.string :account_type
      t.string :subtype

      t.timestamps
    end
  end
end
