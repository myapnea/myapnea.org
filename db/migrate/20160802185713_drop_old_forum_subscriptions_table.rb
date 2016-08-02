class DropOldForumSubscriptionsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :subscriptions do |t|
      t.integer :topic_id
      t.integer :user_id
      t.boolean :subscribed, null: false, default: true
      t.timestamps
      t.index :topic_id
      t.index :user_id
      t.index [:topic_id, :user_id]
    end
  end
end
