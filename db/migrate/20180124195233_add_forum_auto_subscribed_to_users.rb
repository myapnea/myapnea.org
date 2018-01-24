class AddForumAutoSubscribedToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :forum_auto_subscribed, :boolean, null: false, default: false
    add_index :users, :forum_auto_subscribed
  end
end
