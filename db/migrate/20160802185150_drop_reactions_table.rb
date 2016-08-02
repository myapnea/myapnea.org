class DropReactionsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :reactions do |t|
      t.integer :post_id
      t.integer :user_id
      t.string :form
      t.boolean :deleted, default: false, null: false
      t.timestamps
      t.index :post_id
      t.index :user_id
    end
  end
end
