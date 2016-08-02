class DropOldForumsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :forums do |t|
      t.string :name
      t.integer :user_id
      t.text :description
      t.integer :views_count, null: false, default: 0
      t.string :slug
      t.integer :position, null: false, default: 0
      t.boolean :deleted, null: false, default: false
      t.timestamps
      t.index :slug, unique: true
      t.index :user_id
    end
  end
end
