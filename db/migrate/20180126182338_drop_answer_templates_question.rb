class DropAnswerTemplatesQuestion < ActiveRecord::Migration[5.2]
  def change
    drop_table :answer_templates_questions do |t|
      t.integer :question_id
      t.integer :answer_template_id
      t.integer :position, null: false, default: 0
      t.timestamps
      t.index :answer_template_id
      t.index :position
      t.index :question_id
    end
  end
end
