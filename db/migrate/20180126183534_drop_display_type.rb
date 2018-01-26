class DropDisplayType < ActiveRecord::Migration[5.2]
  def change
    drop_table :display_types do |t|
      t.string :name
      t.string :tag
      t.string :input_type
      t.string :tag_class
      t.string :class_string
      t.timestamps
    end
  end
end
