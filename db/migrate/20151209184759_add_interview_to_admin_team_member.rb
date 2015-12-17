class AddInterviewToAdminTeamMember < ActiveRecord::Migration
  def change
    add_column :admin_team_members, :interview, :text
  end
end
