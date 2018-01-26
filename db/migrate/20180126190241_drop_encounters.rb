class DropEncounters < ActiveRecord::Migration[5.2]
  def change
    drop_table :encounters do |t|
      t.integer :survey_id
      t.string :name
      t.string :slug
      t.integer :launch_days_after_sign_up, null: false, default: 0
      t.integer :user_id
      t.boolean :deleted, null: false, default: false
      t.timestamps
      t.index [:survey_id, :deleted]
      t.index :user_id
    end
  end
end
