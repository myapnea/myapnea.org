class RecreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.integer :topic_id
      t.integer :user_id
      t.boolean :subscribed, null: false, default: true
      t.timestamps
      t.index [:topic_id, :user_id], unique: true
      t.index :subscribed
    end
  end
end
