class RemoveHiddenFromTopics < ActiveRecord::Migration[4.2]
  def change
    remove_column :topics, :hidden, :boolean, null: false, default: false
  end
end
