class AddResearchHighlightToHighlights < ActiveRecord::Migration[4.2]
  def change
    add_column :highlights, :research_highlight, :boolean, null: false, default: false
  end
end
