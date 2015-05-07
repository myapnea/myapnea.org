class AddDisplayedToHighlights < ActiveRecord::Migration
  def change
    add_column :highlights, :displayed, :boolean, null: false, default: false
  end
end
