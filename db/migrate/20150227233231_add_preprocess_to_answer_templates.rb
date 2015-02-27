class AddPreprocessToAnswerTemplates < ActiveRecord::Migration
  def change
    add_column :answer_templates, :preprocess, :string
  end
end
