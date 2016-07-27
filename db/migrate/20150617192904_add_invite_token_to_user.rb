class AddInviteTokenToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :invite_token, :string
  end
end
