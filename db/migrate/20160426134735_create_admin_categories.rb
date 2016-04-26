class CreateAdminCategories < ActiveRecord::Migration
  def change
    create_table :admin_categories do |t|
      t.string :name
      t.string :slug
      t.boolean :deleted, null: false, default: false

      t.timestamps null: false
    end

    add_index :admin_categories, :slug, unique: true
    add_index :admin_categories, :deleted
    add_column :broadcasts, :category_id, :integer
    add_index :broadcasts, :category_id
  end
end
