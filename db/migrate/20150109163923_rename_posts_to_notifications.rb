class RenamePostsToNotifications < ActiveRecord::Migration
  def up
    rename_table :posts, :notifications
    remove_index :comments, :post_id
    rename_column :comments, :post_id, :notification_id
    add_index :comments, :notification_id
    rename_column :votes, :post_id, :notification_id
  end

  def down
    rename_column :votes, :notification_id, :post_id
    remove_index :comments, :notification_id
    rename_column :comments, :notification_id, :post_id
    add_index :comments, :post_id
    rename_table :notifications, :posts
  end
end
