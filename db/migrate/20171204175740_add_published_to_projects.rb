class AddPublishedToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :published, :boolean, null: false, default: false
    add_index :projects, :published
  end
end
