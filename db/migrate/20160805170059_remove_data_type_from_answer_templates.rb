class RemoveDataTypeFromAnswerTemplates < ActiveRecord::Migration[5.0]
  def change
    remove_column :answer_templates, :data_type, :string
  end
end
