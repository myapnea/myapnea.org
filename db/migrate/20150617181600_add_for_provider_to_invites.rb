class AddForProviderToInvites < ActiveRecord::Migration[4.2]
  def change
    add_column :invites, :for_provider, :boolean, null: false, default: false
  end
end
