class AddForgetTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :recovery_token, :text
  end
end
