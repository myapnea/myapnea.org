class AddSlugToAdminResources < ActiveRecord::Migration[6.1]
  def change
    add_column :admin_resources, :slug, :string
    add_index :admin_resources, :slug, unique: true
  end
end
