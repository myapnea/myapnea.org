class RemovePositionDefaultFromTeamMembers < ActiveRecord::Migration[5.2]
  def up
    change_column :admin_team_members, :position, :integer, default: nil
  end

  def down
    change_column :admin_team_members, :position, :integer, default: 10
  end
end
