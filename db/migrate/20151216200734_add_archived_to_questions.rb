class AddArchivedToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :archived, :boolean, null: false, default: false
  end
end
