class AddForemTopicsLastPostAt < ActiveRecord::Migration[4.2]
  def up
    add_column :forem_topics, :last_post_at, :datetime
  end

  def down
    remove_column :forem_topics, :last_post_at
  end
end
