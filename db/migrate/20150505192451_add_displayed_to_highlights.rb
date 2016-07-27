class AddDisplayedToHighlights < ActiveRecord::Migration[4.2]
  def change
    add_column :highlights, :displayed, :boolean, null: false, default: false
  end
end
