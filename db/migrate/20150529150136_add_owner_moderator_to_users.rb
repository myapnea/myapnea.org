class AddOwnerModeratorToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :owner, :boolean, null: false, default: false
    add_column :users, :moderator, :boolean, null: false, default: false
    add_index :users, :owner
    add_index :users, :moderator
  end
end
