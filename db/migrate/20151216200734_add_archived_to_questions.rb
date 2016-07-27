class AddArchivedToQuestions < ActiveRecord::Migration[4.2]
  def change
    add_column :questions, :archived, :boolean, null: false, default: false
  end
end
