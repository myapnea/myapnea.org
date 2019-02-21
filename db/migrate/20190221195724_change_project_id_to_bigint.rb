class ChangeProjectIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :projects, :id, :bigint

    change_column :subjects, :project_id, :bigint
  end

  def down
    change_column :projects, :id, :integer

    change_column :subjects, :project_id, :integer
  end
end
