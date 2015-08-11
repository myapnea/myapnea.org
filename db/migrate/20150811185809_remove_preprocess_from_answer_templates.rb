class RemovePreprocessFromAnswerTemplates < ActiveRecord::Migration
  def change
    remove_column :answer_templates, :preprocess, :string
  end
end
