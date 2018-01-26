class DropBroadcastCommentUsers < ActiveRecord::Migration[5.2]
  def change
    drop_table :broadcast_comment_users do |t|
      t.integer :broadcast_id
      t.integer :broadcast_comment_id
      t.integer :user_id
      t.integer :vote, null: false, default: 0
      t.timestamps null: false
      t.index :broadcast_id
      t.index [:broadcast_comment_id, :user_id], name: "index_blog_comment_votes", unique: true
      t.index :vote
    end
  end
end
