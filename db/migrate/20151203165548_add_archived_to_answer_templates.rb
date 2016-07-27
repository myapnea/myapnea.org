class AddArchivedToAnswerTemplates < ActiveRecord::Migration[4.2]
  def change
    add_column :answer_templates, :archived, :boolean, null: false, default: false
  end
end
