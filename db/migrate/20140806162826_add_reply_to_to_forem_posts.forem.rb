class AddReplyToToForemPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :forem_posts, :reply_to_id, :integer
  end
end
