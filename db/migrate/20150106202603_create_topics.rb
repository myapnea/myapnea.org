class CreateTopics < ActiveRecord::Migration[4.2]
  def change
    create_table :topics do |t|
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
      t.timestamps null: false
    end
    add_index :topics, :forum_id
    add_index :topics, :user_id
    add_index :topics, :slug, unique: true
  end
end
