class CreateAnswerOptionsAnswerTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :answr_options_answer_templates do |t|
      t.references :answer_template
      t.references :answer_option
      t.timestamps
    end
  end
end
