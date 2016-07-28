class DropCommentsTable < ActiveRecord::Migration[4.2]
  def up
    remove_index :comments, :notification_id
    drop_table :comments
  end

  def down
    create_table :comments do |t|
      t.text :body, null: false
      t.string :state
      t.integer :user_id
      t.integer :notification_id, null: false
      t.integer :research_topic_id
      t.boolean :deleted, default: false, null: false
      t.timestamps
    end
    add_index :comments, :notification_id
  end
end
