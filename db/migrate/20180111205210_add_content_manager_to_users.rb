class AddContentManagerToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :content_manager, :boolean, null: false, default: false
  end
end
