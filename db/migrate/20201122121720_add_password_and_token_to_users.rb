class AddPasswordAndTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :password_digest, :string
    add_column :users, :token, :string
  end
end
