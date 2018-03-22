class AddInviteTokenToInvites < ActiveRecord::Migration[5.1]
  def change
    add_column :invites, :invite_token, :text
  end
end
