class DropSurveyUserType < ActiveRecord::Migration[5.2]
  def change
    drop_table :survey_user_types do |t|
      t.integer :survey_id
      t.integer :user_id
      t.string :user_type
      t.boolean :deleted, null: false, default: false
      t.timestamps
      t.index [:survey_id, :deleted]
      t.index :user_id
    end
  end
end
