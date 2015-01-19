class RemoveHiddenFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :hidden, :boolean, null: false, default: false
  end
end
