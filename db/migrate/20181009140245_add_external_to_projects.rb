class AddExternalToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :external, :boolean, null: false, default: false
    add_index :projects, :external
    add_column :projects, :external_link, :string
  end
end
