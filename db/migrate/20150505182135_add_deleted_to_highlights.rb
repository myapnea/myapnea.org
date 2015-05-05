class AddDeletedToHighlights < ActiveRecord::Migration
  def change
    add_column :highlights, :deleted, :boolean, null: false, default: false
  end
end
