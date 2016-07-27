class CreateChapterUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :chapter_users do |t|
      t.integer :chapter_id
      t.integer :user_id
      t.integer :current_reply_read_id
      t.integer :last_reply_read_id

      t.timestamps null: false
    end
    add_index :chapter_users, [:chapter_id, :user_id], unique: true
    add_index :chapter_users, :current_reply_read_id
    add_index :chapter_users, :last_reply_read_id
  end
end
