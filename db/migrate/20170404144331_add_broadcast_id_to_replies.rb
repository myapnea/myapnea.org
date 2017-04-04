class AddBroadcastIdToReplies < ActiveRecord::Migration[5.0]
  def change
    add_column :replies, :broadcast_id, :integer
    add_index :replies, :broadcast_id
    add_column :reply_users, :broadcast_id, :integer
    add_index :reply_users, :broadcast_id
  end
end
