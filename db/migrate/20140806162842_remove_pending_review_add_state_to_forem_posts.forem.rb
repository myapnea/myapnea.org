class RemovePendingReviewAddStateToForemPosts < ActiveRecord::Migration[4.2]
  def change
    remove_column :forem_posts, :pending_review, :boolean, default: true
    add_column :forem_posts, :state, :string, default: 'pending_review'
    add_index :forem_posts, :state
  end
end
