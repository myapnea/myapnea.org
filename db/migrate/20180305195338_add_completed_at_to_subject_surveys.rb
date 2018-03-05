class AddCompletedAtToSubjectSurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :subject_surveys, :completed_at, :datetime
    remove_column :subject_surveys, :completed, :boolean, null: false, default: false
  end
end
