class CreateHighlights < ActiveRecord::Migration[4.2]
  def change
    create_table :highlights do |t|
      t.string :title
      t.text :description
      t.string :photo
      t.datetime :display_date
      t.timestamps null: false
    end
  end
end
