class AddShowOnBlogRollToAdminCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_categories, :show_on_blog_roll, :boolean, null: false, default: true
    add_index :admin_categories, :show_on_blog_roll
  end
end
