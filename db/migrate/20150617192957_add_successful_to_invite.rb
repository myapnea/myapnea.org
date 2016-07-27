class AddSuccessfulToInvite < ActiveRecord::Migration[4.2]
  def change
    add_column :invites, :successful, :boolean, null: false, default: false
  end
end
