class RenameExportColumns < ActiveRecord::Migration[5.2]
  def change
    rename_column :admin_exports, :file, :zipped_file
    rename_column :admin_exports, :current_step, :completed_steps
  end
end
