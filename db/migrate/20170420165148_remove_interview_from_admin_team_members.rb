class RemoveInterviewFromAdminTeamMembers < ActiveRecord::Migration[5.0]
  def change
    remove_column :admin_team_members, :interview, :text
  end
end
