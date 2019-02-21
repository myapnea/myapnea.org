class ChangeAdminTeamMemberIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :admin_team_members, :id, :bigint
  end

  def down
    change_column :admin_team_members, :id, :integer
  end
end
