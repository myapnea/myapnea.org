class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.integer :user_id
      t.boolean :pinned, null: false, default: false
      t.datetime :last_reply_at
      t.integer :view_count, null: false, default: 0
      t.boolean :deleted, null: false, default: false

      t.timestamps null: false
    end

    add_index :chapters, :slug
    add_index :chapters, :user_id
    add_index :chapters, :pinned
    add_index :chapters, :last_reply_at
    add_index :chapters, :view_count
    add_index :chapters, :deleted
  end
end
