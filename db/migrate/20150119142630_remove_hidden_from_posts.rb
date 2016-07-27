class RemoveHiddenFromPosts < ActiveRecord::Migration[4.2]
  def change
    remove_column :posts, :hidden, :boolean, null: false, default: false
  end
end
