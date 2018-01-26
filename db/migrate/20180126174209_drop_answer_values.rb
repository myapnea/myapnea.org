class DropAnswerValues < ActiveRecord::Migration[5.2]
  def change
    drop_table :answer_values do |t|
      t.integer :answer_id
      t.integer :answer_template_id
      t.integer :answer_option_id
      t.decimal :numeric_value
      t.string :text_value
      t.datetime :time_value
      t.timestamps
      t.index :answer_id
      t.index :answer_option_id
      t.index :answer_template_id
    end
  end
end
