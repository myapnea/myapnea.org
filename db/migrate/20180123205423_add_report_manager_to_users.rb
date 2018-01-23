class AddReportManagerToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :report_manager, :boolean, null: false, default: false
    add_index :users, :report_manager
  end
end
