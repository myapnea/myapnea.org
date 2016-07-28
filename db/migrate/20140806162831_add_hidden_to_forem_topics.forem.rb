class AddHiddenToForemTopics < ActiveRecord::Migration[4.2]
  def change
    add_column :forem_topics, :hidden, :boolean, :default => false
  end
end
