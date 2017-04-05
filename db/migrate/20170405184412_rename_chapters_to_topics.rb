class RenameChaptersToTopics < ActiveRecord::Migration[5.0]
  def change
    rename_table :chapters, :topics
    rename_table :chapter_users, :topic_users
    rename_column :topic_users, :chapter_id, :topic_id
    rename_column :notifications, :chapter_id, :topic_id
    rename_column :replies, :chapter_id, :topic_id
    rename_column :reply_users, :chapter_id, :topic_id
  end
end
