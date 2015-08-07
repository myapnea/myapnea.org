class CreateEncounters < ActiveRecord::Migration
  def change
    create_table :encounters do |t|
      t.integer :survey_id
      t.string :name
      t.string :slug
      t.integer :launch_days_after_sign_up, null: false, default: 0
      t.integer :user_id
      t.boolean :deleted, null: false, default: false

      t.timestamps null: false
    end

    add_index :encounters, [:survey_id, :deleted]
    add_index :encounters, :user_id
  end
end
