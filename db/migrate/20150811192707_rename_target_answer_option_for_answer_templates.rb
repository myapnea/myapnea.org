class RenameTargetAnswerOptionForAnswerTemplates < ActiveRecord::Migration[4.2]
  def up
    rename_column :answer_templates, :target_answer_option, :parent_answer_option_value
    timestamp = '20150811192707'
    execute "drop view reports"
    execute view_sql(timestamp, :reports)
  end

  def down
    rename_column :answer_templates, :parent_answer_option_value, :target_answer_option
    timestamp = '20150515171427'
    execute "drop view reports"
    execute view_sql(timestamp, :reports)
  end
end
