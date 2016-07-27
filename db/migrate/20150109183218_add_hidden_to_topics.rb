class AddHiddenToTopics < ActiveRecord::Migration[4.2]
  def change
    add_column :topics, :hidden, :boolean, null: false, default: false
  end
end
