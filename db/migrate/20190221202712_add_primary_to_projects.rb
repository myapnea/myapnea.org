class AddPrimaryToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :primary, :boolean, null: false, default: false
    add_index :projects, :primary
  end
end
