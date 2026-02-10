class AddAccessTokenToInstitution < ActiveRecord::Migration[8.1]
  def change
    add_column :institutions, :access_token, :string
  end
end
