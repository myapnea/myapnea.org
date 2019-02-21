class ChangeAdminCategoryIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :admin_categories, :id, :bigint
  end

  def down
    change_column :admin_categories, :id, :integer
  end
end
