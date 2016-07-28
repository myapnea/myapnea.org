class AddPendingReviewToForemTopics < ActiveRecord::Migration[4.2]
  def change
    add_column :forem_topics, :pending_review, :boolean, :default => true
  end
end
