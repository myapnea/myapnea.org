class RemoveExternalAccountsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :validic_id, :string
    remove_column :users, :validic_access_token, :string
    remove_column :users, :oodt_id, :string
  end
end
