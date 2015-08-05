class AddTemplateNameToAnswerTemplates < ActiveRecord::Migration
  def change
    add_column :answer_templates, :template_name, :string
  end
end
