class AddCategoryIdToForums < ActiveRecord::Migration[4.2]
  def change
    add_column :forem_forums, :category_id, :integer
  end
end
