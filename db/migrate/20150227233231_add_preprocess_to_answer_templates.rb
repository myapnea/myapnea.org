class AddPreprocessToAnswerTemplates < ActiveRecord::Migration[4.2]
  def change
    add_column :answer_templates, :preprocess, :string
  end
end
