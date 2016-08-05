class RemoveAllowMultipleFromAnswerTemplates < ActiveRecord::Migration[5.0]
  def change
    remove_column :answer_templates, :allow_multiple, :boolean, null: false, default: false
  end
end
