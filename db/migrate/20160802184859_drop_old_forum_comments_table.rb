class DropOldForumCommentsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :comments do |t|
      t.integer :user_id
      t.integer :post_id
      t.text :content
      t.boolean :deleted, null: false, default: false
      t.timestamps
      t.index :post_id
      t.index :user_id
    end
  end
end
