class CreateSubjectSurveys < ActiveRecord::Migration[5.2]
  def change
    create_table :subject_surveys do |t|
      t.integer :subject_id
      t.string :event
      t.string :design
      t.boolean :completed, null: false, default: false
      t.timestamps
      t.index [:subject_id, :event, :design], unique: true
    end
  end
end
