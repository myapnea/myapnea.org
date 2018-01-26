class DropAnswerOptions < ActiveRecord::Migration[5.2]
  def change
    drop_table :answer_options do |t|
      t.decimal :numeric_value
      t.string :text_value_en
      t.string :text_value_es
      t.datetime :time_value
      t.text :hotkey
      t.integer :value
      t.string :display_class
      t.string :slug
      t.integer :user_id
      t.boolean :deleted, null: false, default: false
      t.timestamps
      t.index :deleted
      t.index :slug
      t.index :user_id
    end
  end
end
