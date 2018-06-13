class RemoveGroupFromAdminTeamMembers < ActiveRecord::Migration[5.2]
  def change
    remove_column :admin_team_members, :group, :string
  end
end
