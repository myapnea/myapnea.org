class AddTemplateNameToAnswerTemplates < ActiveRecord::Migration[4.2]
  def change
    add_column :answer_templates, :template_name, :string
  end
end
