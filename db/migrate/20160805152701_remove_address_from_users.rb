class RemoveAddressFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :address_1, :string
    remove_column :users, :address_2, :string
    remove_column :users, :city, :string
    remove_column :users, :zip_code, :string
  end
end
