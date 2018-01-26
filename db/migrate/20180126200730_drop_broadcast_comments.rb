class DropBroadcastComments < ActiveRecord::Migration[5.2]
  def change
    drop_table :broadcast_comments do |t|
      t.integer :user_id
      t.text :description
      t.integer :broadcast_id
      t.integer :broadcast_comment_id
      t.boolean :deleted, null: false, default: false
      t.timestamps null: false
      t.index :user_id
      t.index :broadcast_id
      t.index :broadcast_comment_id
      t.index :deleted
    end
  end
end
