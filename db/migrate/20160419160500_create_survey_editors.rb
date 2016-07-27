class CreateSurveyEditors < ActiveRecord::Migration[4.2]
  def change
    create_table :survey_editors do |t|
      t.integer :survey_id
      t.integer :user_id
      t.string :invite_token
      t.string :invite_email
      t.integer :creator_id

      t.timestamps null: false
    end

    add_index :survey_editors, :invite_token, unique: true
    add_index :survey_editors, :survey_id
    add_index :survey_editors, :user_id
    add_index :survey_editors, :creator_id
  end
end
