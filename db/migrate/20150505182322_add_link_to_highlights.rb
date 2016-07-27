class AddLinkToHighlights < ActiveRecord::Migration[4.2]
  def change
    add_column :highlights, :link, :string
  end
end
