class AddDeletedToHighlights < ActiveRecord::Migration[4.2]
  def change
    add_column :highlights, :deleted, :boolean, null: false, default: false
  end
end
