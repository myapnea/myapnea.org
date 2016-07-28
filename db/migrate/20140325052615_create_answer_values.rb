class CreateAnswerValues < ActiveRecord::Migration[4.2]
  def change
    create_table :answer_values do |t|
      t.references :answer
      t.references :answer_template
      t.references :answer_option
      t.decimal :numeric_value
      t.string :text_value
      t.datetime :time_value
      t.timestamps
    end
  end
end
