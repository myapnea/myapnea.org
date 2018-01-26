class DropSurveyEditors < ActiveRecord::Migration[5.2]
  def change
    drop_table :survey_editors do |t|
      t.integer :survey_id
      t.integer :user_id
      t.string :invite_token
      t.string :invite_email
      t.integer :creator_id
      t.timestamps
      t.index :invite_token, unique: true
      t.index :survey_id
      t.index :user_id
      t.index :creator_id
    end
  end
end
