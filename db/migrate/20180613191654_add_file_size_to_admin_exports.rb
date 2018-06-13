class AddFileSizeToAdminExports < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_exports, :file_size, :bigint, null: false, default: 0
  end
end
