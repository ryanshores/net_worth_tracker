class CreateInstitutions < ActiveRecord::Migration[8.1]
  def change
    create_table :institutions do |t|
      t.string :name
      t.integer :status

      t.timestamps
    end
  end
end
