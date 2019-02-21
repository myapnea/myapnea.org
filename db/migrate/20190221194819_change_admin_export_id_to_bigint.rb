class ChangeAdminExportIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :admin_exports, :id, :bigint

    change_column :notifications, :admin_export_id, :bigint
  end

  def down
    change_column :admin_exports, :id, :integer

    change_column :notifications, :admin_export_id, :integer
  end
end
