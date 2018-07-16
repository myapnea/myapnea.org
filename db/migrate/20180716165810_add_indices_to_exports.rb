class AddIndicesToExports < ActiveRecord::Migration[5.2]
  def change
    add_index :admin_exports, :file_size
    add_index :admin_exports, :status
  end
end
