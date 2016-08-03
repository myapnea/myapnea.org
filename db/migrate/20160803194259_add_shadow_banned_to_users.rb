class AddShadowBannedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :shadow_banned, :boolean
    add_index :users, :shadow_banned
  end
end
