class AddPendingReviewToForemPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :forem_posts, :pending_review, :boolean, :default => true
  end
end
