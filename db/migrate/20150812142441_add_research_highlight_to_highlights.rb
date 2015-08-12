class AddResearchHighlightToHighlights < ActiveRecord::Migration
  def change
    add_column :highlights, :research_highlight, :boolean, null: false, default: false
  end
end
