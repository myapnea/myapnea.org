class AddDeletedToAnswerTemplates < ActiveRecord::Migration
  def change
    add_column :answer_templates, :deleted, :boolean, null: false, default: false
    add_column :answer_templates, :user_id, :integer
    add_index :answer_templates, :deleted
    add_index :answer_templates, :user_id
  end
end
