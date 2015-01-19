class RemoveHiddenFromTopics < ActiveRecord::Migration
  def change
    remove_column :topics, :hidden, :boolean, null: false, default: false
  end
end
