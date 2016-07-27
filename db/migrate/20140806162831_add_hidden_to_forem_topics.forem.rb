# This migration comes from forem (originally 20110626160056)
class AddHiddenToForemTopics < ActiveRecord::Migration[4.2]
  def change
    add_column :forem_topics, :hidden, :boolean, :default => false
  end
end
