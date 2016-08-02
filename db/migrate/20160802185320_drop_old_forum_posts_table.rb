class DropOldForumPostsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :posts do |t|
      t.integer :topic_id
      t.text :description
      t.integer :user_id
      t.string :status, default: 'pending_review'
      t.integer :last_moderated_by_id
      t.datetime :last_moderated_at
      t.boolean :deleted, null: false, default: false
      t.boolean :links_enabled, null: false, default: false
      t.integer :deleted_by_id
      t.timestamps
      t.index :deleted_by_id
      t.index :last_moderated_by_id
      t.index :topic_id
      t.index :user_id
    end
  end
end
