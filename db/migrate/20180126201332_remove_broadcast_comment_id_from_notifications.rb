class RemoveBroadcastCommentIdFromNotifications < ActiveRecord::Migration[5.2]
  def change
    remove_index :notifications, :broadcast_comment_id
    remove_column :notifications, :broadcast_comment_id, :integer
  end
end
