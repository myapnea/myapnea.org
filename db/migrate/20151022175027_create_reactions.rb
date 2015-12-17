class CreateReactions < ActiveRecord::Migration
  def change
    create_table :reactions do |t|
      t.integer :post_id
      t.integer :user_id
      t.string :form
      t.boolean :deleted, default: false, null: false

      t.timestamps null: false
    end

    add_index :reactions, :post_id
    add_index :reactions, :user_id
  end
end
