class RenameForumNameToUsernameForUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :forum_name, :username
    add_index :users, :username, unique: true
  end
end
