class AddForemTopicsLastPostAt < ActiveRecord::Migration[4.2]
  def change
    add_column :forem_topics, :last_post_at, :datetime
  end
end
