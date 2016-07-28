class RemovePendingReviewFromForemTopicsAddState < ActiveRecord::Migration[4.2]
  def change
    remove_column :forem_topics, :pending_review, :boolean, default: true
    add_column :forem_topics, :state, :string, default: 'pending_review'
    add_index :forem_topics, :state
  end
end
