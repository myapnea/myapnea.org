class CreateReplies < ActiveRecord::Migration[4.2]
  def change
    create_table :replies do |t|
      t.integer :user_id
      t.text :description
      t.integer :chapter_id
      t.integer :reply_id
      t.boolean :deleted, null: false, default: false

      t.timestamps null: false
    end

    add_index :replies, :user_id
    add_index :replies, :chapter_id
    add_index :replies, :reply_id
    add_index :replies, :deleted
  end
end
