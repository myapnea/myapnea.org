class DropAnswerOptionsAnswerTemplates < ActiveRecord::Migration[5.2]
  def change
    drop_table :answr_options_answer_templates do |t|
      t.integer :answer_template_id
      t.integer :answer_option_id
      t.integer :position, null: false, default: 0
      t.timestamps
      t.index :position
      t.index :answer_option_id
      t.index :answer_template_id
    end
  end
end
