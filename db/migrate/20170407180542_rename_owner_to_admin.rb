class RenameOwnerToAdmin < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :owner, :admin
  end
end
