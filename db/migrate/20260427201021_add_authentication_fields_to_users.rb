class AddAuthenticationFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :password_digest, :string
    add_column :users, :remember_token, :string
    add_index :users, :remember_token
    add_index :users, :email, unique: true   # уникальность email
  end
end
