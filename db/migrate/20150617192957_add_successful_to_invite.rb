class AddSuccessfulToInvite < ActiveRecord::Migration
  def change
    add_column :invites, :successful, :boolean, null: false, default: false
  end
end
