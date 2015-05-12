class AddLinksEnabledToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :links_enabled, :boolean, null: false, default: false
  end
end
