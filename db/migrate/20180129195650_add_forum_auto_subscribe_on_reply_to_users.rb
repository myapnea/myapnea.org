class AddForumAutoSubscribeOnReplyToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :forum_auto_subscribe_on_reply, :boolean, null: false, default: true
    add_index :users, :forum_auto_subscribe_on_reply
  end
end
