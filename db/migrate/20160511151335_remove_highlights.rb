class RemoveHighlights < ActiveRecord::Migration
  def up
    drop_table :highlights
  end

  def down
    create_table :highlights do |t|
      t.string :title
      t.text :description
      t.string :photo
      t.datetime :display_date
      t.string :link
      t.boolean :displayed, null: false, default: false
      t.boolean :research_highlight, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.timestamps null: false
    end
  end
end
