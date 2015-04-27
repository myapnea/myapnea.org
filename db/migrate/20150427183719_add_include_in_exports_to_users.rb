class AddIncludeInExportsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :include_in_exports, :boolean, null: false, default: true
  end
end
