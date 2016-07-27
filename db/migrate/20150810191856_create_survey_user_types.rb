class CreateSurveyUserTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :survey_user_types do |t|
      t.integer :survey_id
      t.integer :user_id
      t.string :user_type
      t.boolean :deleted, null: false, default: false

      t.timestamps null: false
    end

    add_index :survey_user_types, [:survey_id, :deleted]
    add_index :survey_user_types, :user_id
  end
end
