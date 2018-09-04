class AddAdminExportIdToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :admin_export_id, :integer
    add_index :notifications, :admin_export_id
  end
end
