class ChangeUserIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :id, :bigint

    change_column :admin_exports, :user_id, :bigint
    change_column :article_votes, :user_id, :bigint
    change_column :broadcasts, :user_id, :bigint
    change_column :images, :user_id, :bigint
    change_column :notifications, :user_id, :bigint
    change_column :projects, :user_id, :bigint
    change_column :replies, :user_id, :bigint
    change_column :reply_users, :user_id, :bigint
    change_column :subjects, :user_id, :bigint
    change_column :subscriptions, :user_id, :bigint
    change_column :topic_users, :user_id, :bigint
    change_column :topics, :user_id, :bigint
  end

  def down
    change_column :users, :id, :integer

    change_column :admin_exports, :user_id, :integer
    change_column :article_votes, :user_id, :integer
    change_column :broadcasts, :user_id, :integer
    change_column :images, :user_id, :integer
    change_column :notifications, :user_id, :integer
    change_column :projects, :user_id, :integer
    change_column :replies, :user_id, :integer
    change_column :reply_users, :user_id, :integer
    change_column :subjects, :user_id, :integer
    change_column :subscriptions, :user_id, :integer
    change_column :topic_users, :user_id, :integer
    change_column :topics, :user_id, :integer
  end
end
