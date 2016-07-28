class CreateDisplayTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :display_types do |t|
      t.string :name
      t.string :tag
      t.string :input_type
      t.string :tag_class
      t.timestamps
    end
  end
end
