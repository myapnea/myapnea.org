class DropCommentsTable < ActiveRecord::Migration
  def up
    remove_index :comments, :notification_id
    drop_table :comments
  end
  def down
    create_table :comments do |t|
      t.text :body, null: false
      t.string :state

      t.references :user
      t.references :notification, null: false
      t.references :research_topic

      t.timestamps
    end
    add_index :comments, :notification_id
  end
end
