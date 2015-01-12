class AddHiddenToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :hidden, :boolean, null: false, default: false
  end
end
