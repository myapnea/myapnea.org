class AddArchivedToAnswerTemplates < ActiveRecord::Migration
  def change
    add_column :answer_templates, :archived, :boolean, null: false, default: false
  end
end
