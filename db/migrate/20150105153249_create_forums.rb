class CreateForums < ActiveRecord::Migration[4.2]
  def change
    create_table :forums do |t|
      t.string :name
      t.integer :user_id
      t.text :description
      t.integer :views_count, null: false, default: 0
      t.string :slug
      t.integer :position, null: false, default: 0
      t.boolean :deleted, null: false, default: false
      t.timestamps null: false
    end
    add_index :forums, :slug, unique: true
    add_index :forums, :user_id
  end
end
