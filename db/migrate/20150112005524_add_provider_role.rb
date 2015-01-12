class AddProviderRole < ActiveRecord::Migration
  def change
    add_column :users, :type, :string
    add_column :users, :slug, :string
    add_column :users, :provider_name, :string


  end
end
