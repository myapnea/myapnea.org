class CreateNotifications < ActiveRecord::Migration[4.2]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.boolean :read, null: false, default: false
      t.integer :broadcast_id
      t.integer :broadcast_comment_id
      t.timestamps null: false
    end
    add_index :notifications, :user_id
    add_index :notifications, :read
    add_index :notifications, :broadcast_id
    add_index :notifications, :broadcast_comment_id
  end
end
