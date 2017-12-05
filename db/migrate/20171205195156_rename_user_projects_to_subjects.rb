class RenameUserProjectsToSubjects < ActiveRecord::Migration[5.2]
  def change
    rename_table :user_projects, :subjects
  end
end
