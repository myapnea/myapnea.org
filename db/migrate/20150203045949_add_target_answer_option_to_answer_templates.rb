class AddTargetAnswerOptionToAnswerTemplates < ActiveRecord::Migration[4.2]
  def change
    add_column :answer_templates, :target_answer_option, :integer
  end
end
