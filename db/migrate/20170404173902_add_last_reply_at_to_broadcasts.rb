class AddLastReplyAtToBroadcasts < ActiveRecord::Migration[5.0]
  def change
    add_column :broadcasts, :last_reply_at, :datetime
    add_index :broadcasts, :last_reply_at
  end
end
