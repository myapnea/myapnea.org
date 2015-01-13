class AddProviderRole < ActiveRecord::Migration
  def change
    add_column :users, :type, :string
    add_column :users, :slug, :string
    add_column :users, :provider_name, :string
    add_column :users, :provider_id, :integer
    add_column :users, :address_1, :string
    add_column :users, :address_2, :string
    add_column :users, :city, :string




  end
end
