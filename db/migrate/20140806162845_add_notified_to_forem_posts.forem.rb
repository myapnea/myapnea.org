class AddNotifiedToForemPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :forem_posts, :notified, :boolean, :default => false
  end
end
