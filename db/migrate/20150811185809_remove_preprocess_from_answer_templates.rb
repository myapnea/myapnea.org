class RemovePreprocessFromAnswerTemplates < ActiveRecord::Migration[4.2]
  def change
    remove_column :answer_templates, :preprocess, :string
  end
end
