class RenameTargetAnswerOptionForAnswerTemplates < ActiveRecord::Migration[4.2]
  def change
    rename_column :answer_templates, :target_answer_option, :parent_answer_option_value
  end
end
