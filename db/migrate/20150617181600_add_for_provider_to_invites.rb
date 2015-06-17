class AddForProviderToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :for_provider, :boolean, null: false, default: false
  end
end
