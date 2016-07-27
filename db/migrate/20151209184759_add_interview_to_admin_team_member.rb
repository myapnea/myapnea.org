class AddInterviewToAdminTeamMember < ActiveRecord::Migration[4.2]
  def change
    add_column :admin_team_members, :interview, :text
  end
end
