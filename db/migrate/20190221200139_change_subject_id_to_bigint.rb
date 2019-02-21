class ChangeSubjectIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :subject_surveys, :subject_id, :bigint
    change_column :subjects, :slice_subject_id, :bigint
  end

  def down
    change_column :subject_surveys, :subject_id, :integer
    change_column :subjects, :slice_subject_id, :integer
  end
end
