class AddSliceSiteIdToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :slice_site_id, :integer
  end
end
