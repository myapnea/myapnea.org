class AddLockedToTopics < ActiveRecord::Migration[5.2]
  def change
    add_column :topics, :locked, :boolean, null: false, default: false
    add_index :topics, :locked
  end
end
