class AddChapterIdAndReplyIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :chapter_id, :integer
    add_column :notifications, :reply_id, :integer
    add_index :notifications, :chapter_id
    add_index :notifications, :reply_id
  end
end
