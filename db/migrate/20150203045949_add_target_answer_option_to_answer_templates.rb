class AddTargetAnswerOptionToAnswerTemplates < ActiveRecord::Migration
  def change
    add_column :answer_templates, :target_answer_option, :integer
  end
end
