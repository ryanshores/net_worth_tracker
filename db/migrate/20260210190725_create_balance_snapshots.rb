class CreateBalanceSnapshots < ActiveRecord::Migration[8.1]
  def change
    create_table :balance_snapshots do |t|
      t.references :account, null: false, foreign_key: true
      t.date :date
      t.decimal :current
      t.decimal :available
      t.string :currency

      t.timestamps
    end
  end
end
