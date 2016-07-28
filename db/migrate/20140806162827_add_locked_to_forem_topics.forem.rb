class AddLockedToForemTopics < ActiveRecord::Migration[4.2]
  def change
    add_column :forem_topics, :locked, :boolean, :null => false, :default => false
  end
end
