class CreateEngagementResponses < ActiveRecord::Migration[4.2]
  def change
    create_table :engagement_responses do |t|
      t.integer :engagement_id
      t.integer :user_id
      t.text :response
      t.boolean :deleted, null: false, default: false

      t.timestamps null: false
    end

    add_index :engagement_responses, [:user_id, :engagement_id], unique: true
  end
end
