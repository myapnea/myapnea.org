class CreateNewComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :post_id
      t.text :content
      t.boolean :deleted, null: false, default: false

      t.timestamps null: false
    end

    add_index :comments, :post_id
    add_index :comments, :user_id
  end
end
