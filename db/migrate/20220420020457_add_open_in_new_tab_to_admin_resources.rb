class AddOpenInNewTabToAdminResources < ActiveRecord::Migration[6.1]
  def change
    add_column :admin_resources, :open_in_new_tab, :boolean, null: false, default: false
  end
end
