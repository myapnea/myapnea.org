class AddForemViewFields < ActiveRecord::Migration[4.2]
  def change
    add_column :forem_views, :current_viewed_at, :datetime
    add_column :forem_views, :past_viewed_at, :datetime
    add_column :forem_topics, :views_count, :integer, default: 0
    add_column :forem_forums, :views_count, :integer, default: 0
  end
end
