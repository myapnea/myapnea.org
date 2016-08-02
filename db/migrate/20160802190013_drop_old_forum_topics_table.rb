class DropOldForumTopicsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :topics do |t|
      t.integer :forum_id
      t.integer :user_id
      t.string :name
      t.boolean :locked, null: false, default: false
      t.boolean :pinned, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.datetime :last_post_at
      t.string :state, default: 'pending_review'
      t.integer :views_count, null: false, default: 0
      t.string :slug
      t.timestamps
      t.index :forum_id
      t.index :user_id
      t.index :slug, unique: true
    end
  end
end
