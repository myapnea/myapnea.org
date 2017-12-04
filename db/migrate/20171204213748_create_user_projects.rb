class CreateUserProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :user_projects do |t|
      t.integer :user_id
      t.integer :project_id
      t.datetime :consented_at
      t.datetime :consent_revoked_at
      t.integer :slice_subject_id
      t.string :slice_subject_code_cache
      t.timestamps
      t.index [:user_id, :project_id], unique: true
    end
  end
end
