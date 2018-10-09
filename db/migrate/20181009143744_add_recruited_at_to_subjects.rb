class AddRecruitedAtToSubjects < ActiveRecord::Migration[5.2]
  def change
    add_column :subjects, :recruited_at, :datetime
  end
end
